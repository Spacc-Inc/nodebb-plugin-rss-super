{{{ each feeds }}}
<div class="feed border-bottom pb-4 my-3">
	<div class="mb-3">
		<label class="form-label">Feed URL</label>
		<input type="text" class="form-control feed-url" placeholder="Enter the RSS feed URL" value="{feeds.url}">
	</div>

	<div class="row mb-3">
		<div class="col-sm-4 col-12 d-flex flex-column gap-1 align-items-start">
			<label class="form-label">Category</label>
			<!-- IMPORT admin/partials/category/selector-dropdown-left.tpl -->
			<input type="text" class="hidden feed-category" value="{feeds.category}">
		</div>
		<div class="col-sm-4 col-12 d-flex flex-column gap-1">
			<label class="form-label">Tags for topics</label>
			<div class="d-flex">
				<input type="text" class="form-control form-control-sm feed-tags" value="{feeds.tags}">
			</div>
		</div>
	</div>

	<div class="row mb-3">
		<div class="col-sm-4 col-12">
			<label class="form-label">
				Include Body
				<input type="checkbox" class="feed-includebody" {{{ if feeds.includeBody }}} checked {{{ end }}} >
			</label>
		</div>
		<div class="col-sm-4 col-12">
			<label class="form-label">Default User</label>
			<input type="text" class="form-control form-control-sm feed-user" value="{feeds.username}">
		</div>
	</div>

	<div class="row">
		<div class="col-sm-3 col-12">
			<label class="form-label">Interval</label>
			<select class="form-select form-select-sm feed-interval" data-interval="{feeds.interval}">
				<option value="1">1 Minute</option>
				<option value="60">1 Hour</option>
				<option value="720">12 Hours</option>
				<option value="1440">24 Hours</option>
				<option value="2880">48 Hours</option>
				<option value="10080">1 week</option>
			</select>
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label"># Entries / Interval</label>
			<input type="text" class="form-control form-control-sm feed-entries-to-pull" placeholder="Number of entries to pull every interval" value="{feeds.entriesToPull}">
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label">Topic Timestamp</label>
			<select class="form-select form-select-sm feed-topictimestamp" data-topictimestamp="{feeds.timestamp}">
				<option value="now">Now</option>
				<option value="feed">Feed Publish Time</option>
			</select>
		</div>

		<div class="col-sm-3 col-12">
			<label class="form-label invisible"></label>
			<button class="btn remove btn-light btn-sm form-control"><i class="fa fa-trash text-danger"></i> Remove</button>
		</div>
	</div>

	<input type="hidden" class="form-control feed-lastEntryDate" value="{feeds.lastEntryDate}">
</div>
{{{ end }}}
