<?php usort($tableGrid, "SiteHelpers::_sort"); ?>
	@include( $pageModule.'/toolbar')

<div class="sbox">
	<div class="sbox-title"> <h4> <i class="fa fa-table"></i> <?php echo $pageTitle ;?> <small>{{ $pageNote }}</small></h4></div>
	<div class="sbox-content"> 	

	 <?php echo Form::open(array('url'=>'{class}/destroy/', 'class'=>'form-horizontal' ,'id' =>'SximoTable'  ,'data-parsley-validate'=>'' )) ;?>
<div class="table-responsive">	
	@if(count($rowData)>=1)
    <table class="table table-striped  " id="{{ $pageModule }}Table">
        <thead>
			<tr>
				<th width="20"> No </th>
				<th width="30"> <input type="checkbox" class="checkall" /></th>		
				@if($setting['view-method']=='expand') <th>  </th> @endif			
				<?php foreach ($tableGrid as $t) :
					if($t['view'] =='1'):
						echo '<th align="'.$t['align'].'">'.SiteHelpers::activeLang($t['label'],(isset($t['language'])? $t['language'] : array())).'</th>';
					endif;
				endforeach; ?>
				<th width="70"><?php echo Lang::get('core.btn_action') ;?></th>
			  </tr>
        </thead>

        <tbody>
        	@if($access['is_add'] =='1' && $setting['inline']=='true')
			<tr id="form-0" >
				<td> # </td>
				<td> </td>
				@if($setting['view-method']=='expand') <td> </td> @endif
				@foreach ($tableGrid as $t)
					@if($t['view'] =='1')
					<td data-form="{{ $t['field'] }}" data-form-type="{{ AjaxHelpers::inlineFormType($t['field'],$tableForm)}}">
						{{ SiteHelpers::transForm($t['field'] , $tableForm) }}								
					</td>
					@endif
				@endforeach
				<td >
					<button onclick="saved('form-0')" class="btn btn-primary btn-xs" type="button"><i class="fa  fa-save"></i></button>
				</td>
			  </tr>	 
			  @endif        
			
           		<?php foreach ($rowData as $row) : 
           			  $id = SiteHelpers::encryptID($row->{key});
           		?>
                <tr class="editable" id="form-{{ $row->{key} }}">
					<td class="number"> <?php echo ++$i;?>  </td>
					<td ><input type="checkbox" class="ids" name="id[]" value="<?php echo $row->{key} ;?>" />  </td>					
					@if($setting['view-method']=='expand')
					<td><a href="javascript:void(0)" class="expandable" rel="#row-{{ $row->{key} }}" data-url="{{ URL::to('{class}/show/'.$id) }}"><i class="fa fa-plus " ></i></a></td>								
					@endif			
					 <?php foreach ($tableGrid as $field) :
					 	if($field['view'] =='1') : 
							$conn = (isset($field['conn']) ? $field['conn'] : array() );
							$value = AjaxHelpers::gridFormater($row->$field['field'], $row , $field['attribute'],$conn);
						 	?>
						 <td align="<?php echo $field['align'];?>" data-values="{{ $row->$field['field'] }}" data-field="{{ $field['field'] }}" data-format="{{ htmlentities($value) }}">					 
							{{ $value }}							 
						 </td>
						 <?php endif;					 
						endforeach; 
					  ?>
				 <td data-values="action" data-key="<?php echo $row->{key} ;?>">
					{{ AjaxHelpers::buttonAction('{class}',$access,$id ,$setting) }}
					{{ AjaxHelpers::buttonActionInline($row->{key},'{key}') }}		
				</td>			 
                </tr>
                @if($setting['view-method']=='expand')
                <tr style="display:none" class="expanded" id="row-{{ $row->{key} }}">
                	<td class="number"></td>
                	<td></td>
                	<td></td>
                	<td colspan="{{ $colspan}}" class="data"></td>
                	<td></td>
                </tr>
                @endif				
            <?php endforeach;?>
              
        </tbody>
      
    </table>
	@else

	<div style="margin:100px 0; text-align:center;">
	
		<p> No Record Found </p>
	</div>
	
	@endif		
	
	</div>
	<?php echo Form::close() ;?>
	
	@include('ajaxfooter')
	</div>
</div>	
	
	@if($setting['inline'] =='true') @include('admin.module.utility.inlinegrid') @endif
<script>
$(document).ready(function() {
	$('.tips').tooltip();	
	$('input[type="checkbox"],input[type="radio"]').iCheck({
		checkboxClass: 'icheckbox_square-green',
		radioClass: 'iradio_square-green',
	});	
	$('#{{ $pageModule }}Table .checkall').on('ifChecked',function(){
		$('#{{ $pageModule }}Table input[type="checkbox"]').iCheck('check');
	});
	$('#{{ $pageModule }}Table .checkall').on('ifUnchecked',function(){
		$('#{{ $pageModule }}Table input[type="checkbox"]').iCheck('uncheck');
	});	
	
	$('#{{ $pageModule }}Paginate .pagination li a').click(function() {
		var url = $(this).attr('href');
		reloadData('#{{ $pageModule }}',url+'&md={{ $masterdetail["filtermd"] }}');		
		return false ;
	});

	<?php if($setting['view-method'] =='expand') :
			echo AjaxHelpers::htmlExpandGrid();
		endif;
	 ?>	
});		
</script>	
<style>
.table th.right { text-align:right !important;}
.table th.center { text-align:center !important;}

</style>
	