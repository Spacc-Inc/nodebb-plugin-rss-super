'use strict';

const crypto = require.main.require('crypto');
const winston = require.main.require('winston');
const db = require.main.require('./src/database');
const meta = require.main.require('./src/meta');
const topics = require.main.require('./src/topics');
const search = require.main.require('./src/search');
const user = require.main.require('./src/user');

const feedAPI = require('./feed');

const Pulling = module.exports;

const turndownService = (new require('turndown'))();

Pulling.pullFeed = async function pullFeed(feed) {
	if (!feed) {
		return;
	}

	try {
		const entries = await feedAPI.getItems(feed.url, feed.entriesToPull);
		entries.reverse();
		for (const entry of entries) {
			// eslint-disable-next-line no-await-in-loop
			await postEntry(feed, entry);
		}
	} catch (err) {
		winston.error(`[unable to pull feed] ${feed.url}`, err);
	}
};

function getEntryDate(entry) {
	if (!entry) {
		return null;
	}
	return entry.published || entry.date || entry.updated || Date.now();
}

async function isEntryNew(feed, entry) {
	const uuid = entry.id || (entry.link && entry.link.href) || entry.title;
	const isMember = await db.isSortedSetMember(`nodebb-plugin-rss:feed:${feed.url}:uuid`, uuid);
	return !isMember;
}

async function postEntry(feed, entry) {
	if (!entry || (!entry.hasOwnProperty('link') || !entry.link || !entry.link.href)) {
		winston.warn(`[nodebb-plugin-rss-super] invalid link for entry,  ${feed.url}`);
		return;
	}

	if (!entry.title || typeof entry.title !== 'string') {
		winston.warn(`[nodebb-plugin-rss-super] invalid title for entry, ${feed.url}`);
		return;
	}

	const isNew = await isEntryNew(feed, entry);
	if (!isNew) {
		winston.info(`[nodebb-plugin-rss-super] entry is not new, id: ${entry.id}, title: ${entry.title}, link: ${entry.link && entry.link.href}`);
		return;
	}

	let posterUid = await user.getUidByUsername(feed.username);
	if (!posterUid) {
		posterUid = 1;
	}

	let tags = [];
	if (feed.tags) {
		tags = feed.tags.split(',');
	}

	// use tags from feed if there are any
	if (Array.isArray(entry.category)) {
		const entryTags = entry.category.map(data => data && data.term).filter(Boolean);
		tags = tags.concat(entryTags);
	}

	winston.info(`[nodebb-plugin-rss-super] posting, ${feed.url} - title: ${entry.title}, published date: ${getEntryDate(entry)}`);

	const content = (feed.includeBody && turndownService.turndown(entry.content) || '');
	const link = (entry.link ? entry.link.href : '');
	const source = (content && link ? '\n\n---\n\n' : '');

	const postData = {
		uid: (feed.manualUser ? posterUid : (await user.getUidByUsername(entry.author) || posterUid)),
		title: entry.title,
		content: (content + source + link),
		cid: feed.category,
		tags: tags,
	};

	// TODO proper HTML parsing & error handling, also prevent wrong results from being found just because they contain the wanted URL
	if (feed.postingMode === 'all') {
		const html = (await (await fetch(entry.link.href)).text()).replaceAll("'", '"');
		const canonical = html.split('<link rel="canonical" href="')[1]?.trim()?.split('"')?.[0]?.trim();

		let hash = crypto.createHash('sha256');
		hash.update(`canonical=${canonical}`);
		hash = `RSS${canonical.length}${hash.digest('hex')}Z`;

		if (canonical) {
			postData.tid = (await search.search({
				searchIn: "posts",
				searchChildren: false,
				query: hash,
			}))?.posts?.[0]?.tid;

			if (!postData.tid) {
				postData.content += `\n\n[_${hash}_]`;
			}
		}
	}

	const result = await ((feed.postingMode === 'all' && postData.tid) ? topics.reply : topics.post)(postData);
	let { topicData } = result;
	topicData ||= { tid: postData.tid };

	if (feed.timestamp === 'feed') {
		setTimestampToFeedPublishedDate(result, entry);
	}

	const max = Math.max(parseInt(meta.config.postDelay, 10) || 10, parseInt(meta.config.newbiePostDelay, 10) || 10) + 1;

	await user.setUserField(posterUid, 'lastposttime', Date.now() - (max * 1000));
	const uuid = entry.id || (entry.link && entry.link.href) || entry.title;
	await db.sortedSetAdd(`nodebb-plugin-rss:feed:${feed.url}:uuid`, topicData.tid, uuid);
}

function setTimestampToFeedPublishedDate(data, entry) {
	const { topicData } = data;
	const { postData } = data;
	const { tid } = topicData;
	const { pid } = postData;
	const timestamp = new Date(getEntryDate(entry)).getTime();

	db.setObjectField(`topic:${tid}`, 'timestamp', timestamp);
	db.sortedSetsAdd([
		'topics:tid',
		`cid:${topicData.cid}:tids`,
		`cid:${topicData.cid}:uid:${topicData.uid}:tids`,
		`uid:${topicData.uid}:topics`,
	], timestamp, tid);

	db.setObjectField(`post:${pid}`, 'timestamp', timestamp);
	db.sortedSetsAdd([
		'posts:pid',
		`cid:${topicData.cid}:pids`,
	], timestamp, pid);
}

