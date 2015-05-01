{{--*/ usort($tableGrid, "SiteHelpers::_sort") /*--}}
<a  class="btn btn-primary btn-sm"  href="javascript:history.go(-1)"> Back To Lists </a><br /><br />
<table class="table table-striped table-bordered" >
<tbody>	
@foreach ($tableGrid as $field)
	@if($field['detail'] ==1)
	<tr>
		<td width='30%' class='label-view text-right'>{{ $field['label']}}</td>
		<td>
			<?php 
				$conn = (isset($field['conn']) ? $field['conn'] : array() );
				echo AjaxHelpers::gridFormater($row->$field['field'], $row , $field['attribute'],$conn);
			?>			
		 </td>
		
	</tr>
	@endif
@endforeach	
</tbody>
</table>	