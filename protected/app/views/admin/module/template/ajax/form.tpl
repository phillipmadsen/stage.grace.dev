
	@if($setting['form-method'] =='native')
	<div class="sbox">
	<div class="sbox-title">  <h4> <i class="fa fa-table"></i> <?php echo $pageTitle ;?> <small>{{ $pageNote }}</small>

	<a href="javascript:void(0)" class="collapse-close pull-right" onclick="ajaxViewClose('#{{ $pageModule }}')"><i class="fa fa fa-times"></i></a>
	</h4>
	 </div>

	<div class="sbox-content"> 
	@endif	
			{{ Form::open(array('url'=>'{class}/save/'.SiteHelpers::encryptID($row['{key}']), 'class'=>'form-{form_display}','files' => true , 'parsley-validate'=>'','novalidate'=>' ','id'=> '{class}FormAjax')) }}
			{form_entry}									
								
						
			<div style="clear:both"></div>	
							
			<div class="form-group">
				<label class="col-sm-4 text-right">&nbsp;</label>
				<div class="col-sm-8">	
					<button type="submit" class="btn btn-primary btn-sm "><i class="fa  fa-save "></i>  {{ Lang::get('core.sb_save') }} </button>
					<button type="button" onclick="ajaxViewClose('#{{ $pageModule }}')" class="btn btn-success btn-sm"><i class="fa  fa-arrow-circle-left "></i>  {{ Lang::get('core.sb_cancel') }} </button>
				</div>			
			</div> 		 
			{{ Form::close() }}

		@foreach($subgrid as $md)
		<hr />
		<div  id="{{ $md['module'] }}">
			<h4><i class="fa fa-table"></i> {{ $md['title'] }}</h4>
			<div id="{{ $md['module'] }}View"></div>
			<div class="table-responsive">
				<div id="{{ $md['module'] }}Grid"></div>
			</div>	
		</div>
		<hr />
		@endforeach	

@if($setting['form-method'] =='native')
	</div>	
</div>	
@endif	

	
</div>	
<script>
$(document).ready(function(){
<?php foreach($subgrid as $md) : 
	$id =  SiteHelpers::encryptID($id) ;
?>
	$.post( '<?php echo URL::to($md['module'].'/detailview/form?md='.$md['master'].'+'.$md['master_key'].'+'.$md['module'].'+'.$md['key'].'+'.$id) ;?>' ,function( data ) {
		$( '#<?php echo $md['module'] ;?>Grid' ).html( data );
	});		
<?php endforeach ?>
});
</script>			 
   <script type="text/javascript">
	$(document).ready(function() { 
		{form_javascript} 
		
		$('.previewImage').fancybox();	
		$('.tips').tooltip();	
		$(".select2").select2({ width:"98%"});	
		$('.date').datepicker({format:'yyyy-mm-dd',autoClose:true})
		$('.datetime').datetimepicker({format: 'yyyy-mm-dd hh:ii:ss'}); 
		 $('.markItUp').markItUp(mySettings );				
		
		var form = $('#{class}FormAjax'); 
		form.parsley();
		form.submit(function(){
			
			if(form.parsley('isValid') == true){			
				var options = { 
					dataType:      'json', 
					beforeSubmit :  showRequest,
					success:       showResponse  
				}  
				$(this).ajaxSubmit(options); 
				return false;
							
			} else {
				return false;
			}		
		
		});

	});
	
	function showRequest()
	{
		$('.formLoading').show();	
	}  
	function showResponse(data)  {		
		
		if(data.status == 'success')
		{
			ajaxViewClose('#{{ $pageModule }}');
			ajaxFilter('#{{ $pageModule }}','{{ $pageUrl }}/data');
			notyMessage(data.message);		
		} else {
			$( ".{{ $pageModule }}FR" ).html( data.message );
			return false;
		}	
	}			 
	
	</script>		 