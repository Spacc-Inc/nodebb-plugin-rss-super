{{{ each feeds }}}
<div class="feed border-bottom pb-4 my-3">
	<div class="mb-3">
		<label class="form-label">Feed URL</label>
		<input type="text" class="form-control feed-url" placeholder="Enter the RSS feed URL" value="{feeds.url}" />
	</div>

	<details>
		<summary>Options</summary>
		<div class="mb-3"></div>

	<div class="row mb-3">
		<div class="col-sm-3 col-12 d-flex flex-column gap-1 align-items-start">
			<label class="form-label">Category</label>
			<!-- IMPORT admin/partials/category/selector-dropdown-left.tpl -->
			<input type="text" class="hidden feed-category" value="{feeds.category}">
		</div>

		<div class="col-sm-3 col-12 d-flex flex-column gap-1">
			<label class="form-label">Tags for topics</label>
			<div class="d-flex">
				<input type="text" class="form-control form-control-sm feed-tags" value="{feeds.tags}" />
			</div>
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label">Creation Mode</label>
			<select class="form-select form-select-sm feed-postingmode" data-postingmode="{feeds.postingMode}">
				<option value="topics">New Topics Only</option>
				<option value="all">New Topics and Replies</option>
				<option value="parent">Append to Parent Topic</option>
			</select>
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label">Parent Topic ID</label>
			<input type="text" class="form-control form-control-sm feed-parenttopic" value="{feeds.parentTopic}" />
		</div>
	</div>

	<div class="row mb-3">
		<div class="col-sm-3 col-12">
			<label class="form-label">Body Format</label>
			<input type="text" class="form-control form-control-sm feed-bodyformat" value="{feeds.bodyFormat}" list="feed-bodyformat-datalist" />
			<datalist id="feed-bodyformat-datalist">
				<option value="#[Link Only]           [[link]] [/#]"></option>
				<option value="#[Title+Link]          [[title]]\n\n[[link]] [/#]"></option>
				<option value="#[Title+Link (HTML)]   [[title]]\n\n&lt;div class=&apos;link-container&apos;&gt;\n\n[[link]]\n\n&lt;/div&gt; [/#]"></option>
				<option value="#[Snippet+Link]        [[snippet]]\n\n[[link]] [/#]"></option>
				<option value="#[Snippet+Link (HTML)] [[snippet]]\n\n&lt;div class=&apos;link-container&apos;&gt;\n\n[[link]]\n\n&lt;/div&gt; [/#]"></option>
				<option value="#[Content+Link]        [[content]]\n\n---\n\n[[link]] [/#]"></option>
				<option value="#[Content+Link (HTML)] [[content]]\n\n&lt;div class=&apos;link-container&apos;&gt;\n\n[[link]]\n\n&lt;/div&gt; [/#]"></option>
			</datalist>
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label">Default User</label>
			<input type="text" class="form-control form-control-sm feed-user" value="{feeds.username}" />
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label">
				Force Default User
				<input type="checkbox" class="feed-manualuser" {{{ if feeds.manualUser }}} checked {{{ end }}} />
			</label>
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label invisible"></label>
			<button class="btn remove btn-light btn-sm form-control"><i class="fa fa-trash text-danger"></i> Remove</button>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-3 col-12">
			<label class="form-label">Interval</label>
			<select class="form-select form-select-sm feed-interval" data-interval="{feeds.interval}">
				<option value="1">1 Minute</option>
				<option value="2">2 Minutes</option>
				<option value="3">3 Minutes</option>
				<option value="5">5 Minutes</option>
				<option value="10">10 Minutes</option>
				<option value="15">15 Minutes</option>
				<option value="20">20 Minutes</option>
				<option value="30">30 Minutes</option>
				<option value="60">1 Hour</option>
				<option value="120">2 Hours</option>
				<option value="180">3 Hours</option>
				<option value="360">6 Hours</option>
				<option value="720">12 Hours</option>
				<option value="1440">24 Hours</option>
				<option value="2880">48 Hours</option>
				<option value="10080">1 Week</option>
			</select>
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label"># Entries / Interval</label>
			<input type="text" class="form-control form-control-sm feed-entries-to-pull" placeholder="Number of entries to pull every interval" value="{feeds.entriesToPull}" />
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label">Topic Timestamp</label>
			<select class="form-select form-select-sm feed-topictimestamp" data-topictimestamp="{feeds.timestamp}">
				<option value="now">Now</option>
				<option value="feed">Feed Publish Time</option>
			</select>
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label">Entry Delay</label>
			<select class="form-select form-select-sm feed-delay" data-delay="{feeds.delay}">
				<option value="60">1 Minute</option>
				<option value="120">2 Minutes</option>
				<option value="180">3 Minutes</option>
				<option value="300">5 Minutes</option>
				<option value="600">10 Minutes</option>
				<option value="900">15 Minutes</option>
				<option value="1200">20 Minutes</option>
				<option value="1800">30 Minutes</option>
				<option value="3600">1 Hour</option>
				<option value="7200">2 Hours</option>
				<option value="10800">3 Hours</option>
				<option value="21600">6 Hours</option>
			</select>
		</div>
	</div>

	</details>

	<input type="hidden" class="form-control feed-lastEntryDate" value="{feeds.lastEntryDate}" />
</div>
{{{ end }}}
