'use strict';

const cron = require('cron').CronJob;

const winston = require.main.require('winston');
const nconf = require.main.require('nconf');
const plugins = require.main.require('./src/plugins');
const pubsub = require.main.require('./src/pubsub');


let pullFeedsInterval;

const cronJobs = [
	new cron('0 * * * * *',    (() => { pullFeedsInterval(1); }), null, false), // 1 minute
	new cron('0 */2 * * * *',  (() => { pullFeedsInterval(2); }), null, false), // 2 minutes
	new cron('0 */3 * * * *',  (() => { pullFeedsInterval(3); }), null, false), // 3 minutes
	new cron('0 */5 * * * *',  (() => { pullFeedsInterval(5); }), null, false), // 5 minutes
	new cron('0 */10 * * * *', (() => { pullFeedsInterval(10); }), null, false), // 10 minutes
	new cron('0 */15 * * * *', (() => { pullFeedsInterval(15); }), null, false), // 15 minutes
	new cron('0 */20 * * * *', (() => { pullFeedsInterval(20); }), null, false), // 20 minutes
	new cron('0 */30 * * * *', (() => { pullFeedsInterval(30); }), null, false), // 30 minutes
	new cron('0 0 * * * *',    (() => { pullFeedsInterval(60); }), null, false), // 1 hour
	new cron('0 0 */2 * * *',  (() => { pullFeedsInterval(60 * 2); }), null, false), // 2 hour
	new cron('0 0 */3 * * *',  (() => { pullFeedsInterval(60 * 3); }), null, false), // 3 hour
	new cron('0 0 */6 * * *',  (() => { pullFeedsInterval(60 * 6); }), null, false), // 6 hour
	new cron('0 0 0/12 * * *', (() => { pullFeedsInterval(60 * 12); }), null, false), // 12 hours
	new cron('0 0 0 * * *',    (() => { pullFeedsInterval(60 * 24); }), null, false), // 24 hours
	new cron('0 0 0 */2 * *',  (() => { pullFeedsInterval(60 * 24 * 2); }), null, false), // 48 hours
	new cron('0 0 0 * * 6',    (() => { pullFeedsInterval(60 * 24 * 7); }), null, false), // 1 week
];

const Jobs = module.exports;

Jobs.init = function (pullMethod) {
	pullFeedsInterval = pullMethod;
};

plugins.isActive('nodebb-plugin-rss-super', (err, active) => {
	if (err) {
		return winston.error(err.stack);
	}

	if (active) {
		reStartCronJobs();
	}
});

function reStartCronJobs() {
	if (nconf.get('runJobs')) {
		stopCronJobs();
		cronJobs.forEach((job) => {
			job.start();
		});
	}
}

function stopCronJobs() {
	if (nconf.get('runJobs')) {
		cronJobs.forEach((job) => {
			job.stop();
		});
	}
}

pubsub.on('nodebb-plugin-rss-super:deactivate', () => {
	stopCronJobs();
});
