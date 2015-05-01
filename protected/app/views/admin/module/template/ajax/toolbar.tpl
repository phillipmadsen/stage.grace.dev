    <div class="m-b row">
    	<div class="col-md-6 m-b ">
    		<div class="btn-group ">
			@if($access['is_add'] ==1)
			{{ AjaxHelpers::buttonActionCreate($pageModule,'modal')}}
			<button type="button" onclick="ajaxCopy('#{{ $pageModule }}','{{ $pageUrl }}')" class="tips btn btn-info btn-xs" title="Copy Row(s)"><i class="fa fa-file" ></i> Copy </button>
			@endif  
			@if($access['is_remove'] ==1)
			<a href="javascript://ajax"  onclick="ajaxRemove('#{{ $pageModule }}','{{ $pageUrl }}');" class="tips btn btn-xs btn-danger" title="{{ Lang::get('core.btn_remove') }}">
			<i class="fa fa-trash-o"></i>&nbsp;{{ Lang::get('core.btn_remove') }}</a>
			@endif 	
			<a href="javascript:void(0)" class="tips btn btn-xs btn-default" 
			onclick="reloadData('#{{ $pageModule }}','{{ $pageUrl }}/data?md={{ $masterdetail["filtermd"] }}')"  title="Reload Data"><i class="fa fa-refresh"></i> Reload </a>
			</div>			
		</div>
		<div class="col-md-6 m-b ">				
			<div class="btn-group pull-right m-b ">
				@if($access['is_excel'] ==1)
				<div class="btn-group">				
				   <button type="button" class="btn btn-primary btn-xs dropdown-toggle tips"  title=" {{ Lang::get('core.btn_download') }} "
					  data-toggle="dropdown">
					  <i class="fa fa-download"></i> {{ Lang::get('core.btn_download') }} <span class="caret"></span>
				   </button>
				   <ul class="dropdown-menu" role="menu">
					  <li><a href="{{ URL::to( $pageModule .'/export/excel?md='.$masterdetail["filtermd"].$trackUri) }}" title="Export to Excel" > Export Excel </a></li>
					   <li><a href="{{ URL::to( $pageModule .'/export/pdf?md='.$masterdetail["filtermd"].$trackUri) }}" title="Export to PDF" > Export PDF </a></li>
					  <li><a href="{{ URL::to( $pageModule .'/export/word?md='.$masterdetail["filtermd"].$trackUri) }}"  title="Export to Word"> Export Word </a></li>
					  <li><a href="{{ URL::to( $pageModule .'/export/csv?md='.$masterdetail["filtermd"].$trackUri) }}"   title="Export to CSV"> Export CSV</a></li>
				   </ul>
				</div> 			
				@endif
				<a href="{{ URL::to( $pageModule .'/search') }}" onclick="SximoModal(this.href,'Advance Search'); return false;" class="tips btn btn-xs btn-warning"  title=" Search ">
				<i class="fa fa-search"></i> Search </a>	
				<a href="{{ URL::to( $pageModule .'/export/print?md='.$masterdetail["filtermd"].$trackUri) }}" onclick="ajaxPopupStatic(this.href); return false;" class="tips btn btn-xs btn-info"  title=" Print ">
				<i class="fa fa-print"></i> Print </a>			
				@if(Session::get('gid') ==1)
				<a href="{{ URL::to('module/config/'.$pageModule) }}" class="tips btn btn-xs btn-default"  title="{{ Lang::get('core.btn_config') }}">
				<i class="fa fa-cogs"></i>&nbsp; {{ Lang::get('core.btn_config') }}</a>	
				@endif 
								
			</div>
		</div>						
		
	</div> 