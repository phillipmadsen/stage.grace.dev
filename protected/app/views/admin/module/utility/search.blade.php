<div >
<form id="{{$pageModule}}Search">
<table class="table search-table table-striped">
	<tbody>
@foreach ($tableForm as $t)
	@if($t['search'] =='1')
		<tr>
			<td>{{ SiteHelpers::activeLang($t['label'],(isset($t['language'])? $t['language'] : array())) }} </td>
			<td>{{ SiteHelpers::transForm($t['field'] , $tableForm) }}</td>
		
		</tr>
	
	@endif
@endforeach
		<tr>
			<td></td>
			<td><button type="button" name="search" class="doSearch btn btn-sm btn-primary"> Search </button></td>
		
		</tr>
	</tbody>     
	</table>
</form>	
</div>
<script>
jQuery(function(){
		$('.date').datepicker({format:'yyyy-mm-dd',autoClose:true})
		$('.datetime').datetimepicker({format: 'yyyy-mm-dd hh:ii:ss'}); 	
	$('.doSearch').click(function(){
		var attr = '';
		$( '#{{$pageModule}}Search :input').each(function() {
			if(this.value !=='' && this.name !='_token') { attr += this.name+':'+this.value+'|'; }
		});
		reloadData( '#{{ $pageModule }}',"{{ $pageUrl }}/data?search="+attr);	
		$('#sximo-modal').modal('hide');
	});
});

</script>
