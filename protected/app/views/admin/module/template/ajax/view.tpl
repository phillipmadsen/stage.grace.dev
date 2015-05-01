
	@if($setting['view-method'] =='native')
	<div class="sbox">
	<div class="sbox-title">  <h4> <i class="fa fa-table"></i> <?php echo $pageTitle ;?> <small>{{ $pageNote }}</small>

	<a href="javascript:void(0)" class="collapse-close pull-right" onclick="ajaxViewClose('#{{ $pageModule }}')"><i class="fa fa fa-times"></i></a>
	</h4>
	 </div>

	<div class="sbox-content"> 
	@endif	

		<table class="table table-striped table-bordered" >
			<tbody>	
				{form_view}
			</tbody>	
		</table>  	
			
		@foreach($subgrid as $md)
		<hr />
		<div  id="{{ $md['module'] }}">
			<h4><i class="fa fa-table"></i> {{ $md['title'] }}</h4>
			<hr />
			<div id="{{ $md['module'] }}View"></div>
			<div class="table-responsive">
				<div id="{{ $md['module'] }}Grid-{{ $id }}"></div>
			</div>	
			<hr />
		</div>
		@endforeach

@if($setting['form-method'] =='native')
	</div>	
</div>	
@endif	
<script>
$(document).ready(function(){
<?php foreach($subgrid as $md) : ?>
	$.post( '<?php echo URL::to($md['module'].'/detailview?md='.$md['master'].'+'.$md['master_key'].'+'.$md['module'].'+'.$md['key'].'+'.$id) ;?>' ,function( data ) {
		$( '#<?php echo $md['module'] ;?>Grid-{{ $id }}' ).html( data );
	});		
<?php endforeach ?>
});
</script>	