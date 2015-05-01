  {{ HTML::script('sximo/js/simpleclone.js') }}
  <div class="page-content row">
    <!-- Page header -->
    <div class="page-header">
      <div class="page-title">
        <h3> Database Tables  <small> Manage Database Tables </small> <sup><label class="label label-warning"> Beta Version </label></sup></h3>
      </div>
	  
	 
	  <ul class="breadcrumb">
		<li><a href="{{ URL::to('dashboard') }}">{{ Lang::get('core.home'); }}</a></li>
		<li><a href="{{ URL::to('module') }}"> Module </a></li>
		<li><a href="{{ URL::to('config') }}">Tables </a></li>
	  </ul>	  
	 
    </div>

 	<div class="page-content-wrapper m-t">
			<div class="alert alert-warning fade in block-inner">
				<button data-dismiss="alert" class="close" type="button"> x </button>
			<i class="icon-warning"></i> This feature is still in <strong>BETA version </strong> , if you have trouble or issues  , please report on  Our <a href="https://github.com/mangopik/Sximo-Laravel/issues" target="_blank">Github </a></div>

	
	@if(Session::has('message'))
	  
		   {{ Session::get('message') }}
	   
	@endif 	
 		<div class="ajaxLoading"></div>
			<div class="sbox">

			<div class="sbox-title"><i class="icon-database"></i> Database Tables  
			<span class="pull-right">	
				<a href="{{ URL::TO('config/tableconfig/')}}" class="btn btn-xs btn-primary linkConfig"><i class="fa fa-plus"></i> New Table </a>
				<a href="{{ URL::TO('config/mysqleditor/')}}" class="btn btn-xs btn-success linkConfig"><i class="fa fa-pencil"></i> MySQL Editor </a>
			</span>	
			</div>
			<div class="sbox-content">

			

			<div class="row">
				<div class="col-md-3">
					{{ Form::open(array('url'=>'config/tableremove/', 'class'=>'form-horizontal','id'=>'removeTable' )) }}
					<div class="table-responsive">
						<table class="table table-striped">
							<thead>
								<tr>
									
									<th width="30"> <input type="checkbox" class="checkall i-checks-all " /></th>
									<th> Table Name </th>
									<th width="50"> Action </th>
								</tr>
							</thead>
							<tbody>
							@foreach($tables as $table)
								<tr>
									<td><input type="checkbox" class="ids  i-checks" name="id[]" value="{{ $table }}" /> </td>
									<td><a href="{{ URL::TO('config/tableconfig/'.$table)}}" class="linkConfig" > {{ $table }}</a></td>
									<td>
									<a href="javascript:void(0)" onclick="droptable()" class="btn btn-xs btn-danger"><i class="fa fa-minus"></i></a>
									</td>
								</tr>
							@endforeach
							</tbody>
						
						</table>
					
					</div>
					{{ Form::close() }}		
				</div>
				<div class="col-md-9">
					
					<div class="tableconfig" style="background:#fff; padding:10px; min-height:300px; border:solid 1px #ddd;">

					</div>

				</div>

			</div>
		</div>
		</div>
	
	</div>
</div>	  
<script type="text/javascript">
$(document).ready(function(){

	$('.linkConfig').click(function(){
		$('.ajaxLoading').show();
		var url =  $(this).attr('href');
		$.get( url , function( data ) {
			$( ".tableconfig" ).html( data );
			$('.ajaxLoading').hide();
			
			
		});
		return false;
	});
});

function droptable()
{
	if(confirm('are you sure remove selected table(s) ?'))
	{
		$('#removeTable').submit();
	} else {
		return false;
	}
}

</script>