{{--*/ usort($tableGrid, "SiteHelpers::_sort") /*--}}
  <div class="page-content row">
    <!-- Page header -->
    <div class="page-header">
      <div class="page-title">
        <h3> {{ $pageTitle }} <small>{{ $pageNote }}</small></h3>
      </div>

      <ul class="breadcrumb">
        <li><a href="{{ URL::to('dashboard') }}">{{ Lang::get('core.home') }}</a></li>
        <li class="active">{{ $pageTitle }}</li>
      </ul>	  
	  
    </div>
	
	
	<div class="page-content-wrapper">
    <div class="toolbar-line row">
    	<div class="col-md-6 m-b ">
    		<div class="btn-group ">
				@if($access['is_add'] ==1)
		   		<a href="{{ URL::to('{class}/add?md='.$masterdetail["filtermd"].$trackUri) }}" class="tips btn btn-xs btn-primary"  title="{{ Lang::get('core.btn_create') }}">
				<i class="fa fa-plus-circle"></i>&nbsp;{{ Lang::get('core.btn_create') }}</a>
				<button type="button" onclick="ajaxCopy('#{class}','{{ URL::to('{class}')}}')" class="tips btn btn-info btn-xs" title="Copy Row(s)"><i class="fa fa-file" ></i> Copy </button>
				@endif  
				@if($access['is_remove'] ==1)
				<a href="javascript://ajax"  onclick="SximoDelete();" class="tips btn btn-xs btn-danger" title="{{ Lang::get('core.btn_remove') }}">
				<i class="fa fa-trash-o"></i>&nbsp;{{ Lang::get('core.btn_remove') }}</a>
				@endif 	
			</div>
		</div>
    	<div class="col-md-6 m-b ">
    		<div class="btn-group pull-right">	

				@if($access['is_excel'] ==1)
				<div class="btn-group">				
				   <button type="button" class="btn btn-primary btn-xs dropdown-toggle tips"  title=" {{ Lang::get('core.btn_download') }} "
					  data-toggle="dropdown">
					  <i class="fa fa-cloud-download"></i> {{ Lang::get('core.btn_download') }} <span class="caret"></span>
				   </button>
				   <ul class="dropdown-menu" role="menu">
					  <li><a href="{{ URL::to('{class}/export/excel?md='.$masterdetail["filtermd"]) }}" title="Export to Excel" ><i class="fa fa-cloud-download"></i> Export Excel </a></li>
					  <li><a href="{{ URL::to('{class}/export/pdf?md='.$masterdetail["filtermd"]) }}" title="Export to PDF" ><i class="fa fa-cloud-download"></i> Export PDF </a></li>
					  <li><a href="{{ URL::to( '{class}/export/word?md='.$masterdetail["filtermd"]) }}"  title="Export to Word"><i class="fa fa-cloud-download"></i> Export Word </a></li>
					  <li><a href="{{ URL::to('{class}/export/csv?md='.$masterdetail["filtermd"]) }}"   title="Export to CSV"><i class="fa fa-cloud-download"></i> Export CSV</a></li>
				   </ul>
				</div> 	
				@endif	
				<a href="{{ URL::to( '{class}/export/print?md='.$masterdetail["filtermd"]) }}" onclick="ajaxPopupStatic(this.href); return false;" class="tips btn btn-xs btn-info"  title=" Print ">
					<i class="fa fa-print"></i> Print </a>		
			 	@if(Session::get('gid') ==1)
				<a href="{{ URL::to('module/config/{class}') }}" class="tips btn btn-xs btn-default"  title="{{ Lang::get('core.btn_config') }}">
				<i class="fa fa-cog"></i>&nbsp;{{ Lang::get('core.btn_config') }} </a>	
				@endif 
			</div>
		</div>		 			
	 
	</div> 	
	 
		
	@if(Session::has('message'))	  
		   {{ Session::get('message') }}
	@endif	
<div class="sbox animated fadeInRight">
	<div class="sbox-title"> <h4> <i class="fa fa-table"></i> <?php echo $pageTitle ;?> <small>{{ $pageNote }}</small></h4></div>
	<div class="sbox-content"> 	

	{{ $details }}
	
	 {{ Form::open(array('url'=>'{class}/destroy/', 'class'=>'form-horizontal' ,'id' =>'SximoTable' )) }}
	 <div class="table-responsive" style="min-height:400px;">
    <table class="table table-striped ">
        <thead>
			<tr>
				<th> No </th>
				<th> <input type="checkbox" class="checkall" /></th>
				
				@foreach ($tableGrid as $t)
					@if($t['view'] =='1')
						<th>{{ $t['label'] }}</th>
					@endif
				@endforeach
				<th>{{ Lang::get('core.btn_action') }}</th>
			  </tr>
        </thead>

        <tbody>
			<tr id="sximo-quick-search" >
				<td> # </td>
				<td> </td>
				@foreach ($tableGrid as $t)
					@if($t['view'] =='1')
					<td>						
						{{ SiteHelpers::transForm($t['field'] , $tableForm) }}								
					</td>
					@endif
				@endforeach
				<td style="width:130px;">
				<input type="hidden"  value="Search">
				<button type="button"  class=" do-quick-search btn btn-xs btn-info"> <i class="fa fa-search"></i></button></td>
			  </tr>				
            @foreach ($rowData as $row)
                <tr>
					<td width="50"> {{ ++$i }} </td>
					<td width="50"><input type="checkbox" class="ids" name="id[]" value="{{ $row->{key} }}" />  </td>									
				 @foreach ($tableGrid as $field)
					 @if($field['view'] =='1')
					 <td>					 
					 	<?php 
							$conn = (isset($field['conn']) ? $field['conn'] : array() );
							echo AjaxHelpers::gridFormater($row->$field['field'], $row , $field['attribute'],$conn);?>						 
					 </td>
					 @endif					 
				 @endforeach
				 <td>
					 <div class="btn-group">		
						<button class="btn btn-primary btn-xs dropdown-toggle" data-toggle="dropdown"  aria-expanded="false">
						<i class="fa fa-cog"></i> <span class="caret"></span>
						</button>
						<ul  class="dropdown-menu  icons-left pull-right">					 	
						{{--*/ $id = SiteHelpers::encryptID($row->{key}) /*--}}
					 	@if($access['is_detail'] ==1)
						<li><a href="{{ URL::to('{class}/show/'.$id.'?md='.$masterdetail["filtermd"].$trackUri)}}" ><i class="fa  fa-search"></i> {{ Lang::get('core.btn_view') }}</a></li>
						@endif
						@if($access['is_edit'] ==1)
						<li><a  href="{{ URL::to('{class}/add/'.$id.'?md='.$masterdetail["filtermd"].$trackUri)}}" ><i class="fa fa-edit"></i> {{ Lang::get('core.btn_edit') }}</a></li>
						@endif
						@foreach($subgrid as $md)
						<li><a href="{{ URL::to($md['module'].'?md='.$md['master'].'+'.$md['master_key'].'+'.$md['module'].'+'.$md['key'].'+'.$id) }}" ><i class="icon-eye2"></i> {{ $md['title'] }}</a></li>
						@endforeach							
						</ul>
					</div>	
				</td>				 
                </tr>
				
            @endforeach
              
        </tbody>
      
    </table>
	<input type="hidden" name="md" value="{{ $masterdetail['filtermd']}}" />
	</div>
	{{ Form::close() }}
	@include('footer')

</div>
</div>	
	
	</div>	  
</div>	
<script>
$(document).ready(function(){

	$('.do-quick-search').click(function(){
		$('#SximoTable').attr('action','{{ URL::to("{class}/multisearch")}}');
		$('#SximoTable').submit();
	});
	
});	

function ajaxCopy(  id , url )
{
	if(confirm('Are u sure copy selected row(s)?')) {
		$('#SximoTable').attr('action','{{ URL::to("{class}/copy")}}');
		$('#SximoTable').submit();		
	}	
}
</script>		