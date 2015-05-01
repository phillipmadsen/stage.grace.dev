<?php
class {controller}Controller extends BaseController {

	protected $layout = "layouts.main";
	protected $data = array();	
	public $module = '{class}';
	static $per_page	= '10';
	
	public function __construct() {
		parent::__construct();
		$this->model = new {controller}();
		$this->info = $this->model->makeInfo( $this->module);
		$this->access = $this->model->validAccess($this->info['id']);
	
		$this->data = array(
			'pageTitle'			=> 	$this->info['title'],
			'pageNote'			=>  $this->info['note'],
			'pageModule'		=> '{class}',
			'pageUrl'			=>  URL::to('{class}'),
			'trackUri' 			=> 	$this->trackUriSegmented()			
		);
			
				
	} 
	
	public function getIndex()
	{
		if($this->access['is_view'] ==0) 
			return Redirect::to('')
				->with('message', SiteHelpers::alert('error',Lang::get('core.note_restric')));	
				
		$this->data['access']		= $this->access;	
		$master  = $this->buildMasterDetail(); 
		$this->data['masterdetail']  = $this->masterDetailParam(); 
		$this->layout->nest('content','{class}.index',$this->data);
	}		
		

	public function postData()
	{ 
		if($this->access['is_view'] ==0) { echo SiteHelpers::alert('error',Lang::get('core.note_restric')); die; }	
		
		$sort = (!is_null(Input::get('sort')) ? Input::get('sort') : $this->info['setting']['orderby']); 
		$order = (!is_null(Input::get('order')) ? Input::get('order') : $this->info['setting']['ordertype']);	
		$filter = (!is_null(Input::get('search')) ? $this->buildSearch() : '');
		$page = Input::get('page', 1);
		$master  = $this->buildMasterDetail(); 
		$filter .=  $master['masterFilter'];		
		$params = array(
			'page'		=> $page ,
			'limit'		=> (!is_null(Input::get('rows')) ? filter_var(Input::get('rows'),FILTER_VALIDATE_INT) : $this->info['setting']['perpage'] ) ,
			'sort'		=> $sort ,
			'order'		=> $order,
			'params'	=> $filter,
			'global'	=> (isset($this->access['is_global']) ? $this->access['is_global'] : 0 )
		);
			
		$results = $this->model->getRows( $params );	
		
		$this->data['param']		= $params;
		$this->data['rowData']		= $results['rows'];
		$this->data['tableGrid'] 	= $this->info['config']['grid'];
		$this->data['tableForm'] 	= $this->info['config']['forms'];	
		$this->data['access']		= $this->access;	
		$this->data['subgrid']	= (isset($this->info['config']['subgrid']) ? $this->info['config']['subgrid'] : array()); 
		$this->data['masterdetail']  = $this->masterDetailParam(); 
		$this->data['colspan'] 		= SiteHelpers::viewColSpan($this->info['config']['grid']);
		$this->data['setting'] 		= $this->info['setting'];
		// Build pagination setting
		$page = $page >= 1 && filter_var($page, FILTER_VALIDATE_INT) !== false ? $page : 1;	
		$pagination = Paginator::make($results['rows'], $results['total'],$params['limit']);		
		// Build Pagination 
		$this->data['pagination']	= $pagination;
		// Build pager number and append current param GET
		$this->data['pager'] 		= $this->injectPaginate();	
		// Row grid Number 
		$this->data['i']			= ($page * $params['limit'])- $params['limit']; 
				
		return View::make('{class}.table',$this->data);

	}	


	function getAdd( $id = null)
	{
		if($id =='')
		{
			if($this->access['is_add'] ==0 ) { echo SiteHelpers::alert('error',Lang::get('core.note_restric')); die; }	 
		}	
		
		if($id !='')
		{
			if($this->access['is_edit'] ==0 ) { echo SiteHelpers::alert('error',Lang::get('core.note_restric')); die; }	 
		}				
			
		$id = ($id == null ? '' : SiteHelpers::encryptID($id,true)) ;
		
		$row = $this->model->find($id);
		if($row)
		{
			$this->data['row'] =  $row;
		} else {
			$this->data['row'] = $this->model->getColumnTable('{table}'); 
		}

		/* Master detail lock key and value */
		if(!is_null(Input::get('md')) && Input::get('md') !='')
		{
			$filters = explode(" ", Input::get('md') );
			$this->data['row'][$filters[3]] = SiteHelpers::encryptID($filters[4],true); 	
		}
		/* End Master detail lock key and value */
		$this->data['subgrid']	= (isset($this->info['config']['subgrid']) ? $this->info['config']['subgrid'] : array()); 
		$this->data['masterdetail']  = $this->masterDetailParam(); 
		$this->data['filtermd'] = str_replace(" ","+",Input::get('md')); 			
		$this->data['fields'] =  AjaxHelpers::fieldLang($this->info['config']['forms']);
		$this->data['id'] = $id;
		$this->data['setting'] 		= $this->info['setting'];
		return View::make('{class}.form',$this->data);
		
	}
			
	
	function getShow( $id = null)
	{
	
		if($this->access['is_detail'] ==0) { echo SiteHelpers::alert('error',Lang::get('core.note_restric')); die; }						
		$ids = (is_numeric($id) ? $id : SiteHelpers::encryptID($id,true)  );
		$row = $this->model->getRow($ids);
		if($row)
		{
			$this->data['row'] =  $row;
		} else {
			$this->data['row'] = $this->model->getColumnTable('{table}'); 
		}
		$this->data['subgrid']	= (isset($this->info['config']['subgrid']) ? $this->info['config']['subgrid'] : array()); 
		$this->data['id'] = $id;
		$this->data['setting'] 		= $this->info['setting'];
		$this->data['access']		= $this->access;
		$this->data['fields'] =  AjaxHelpers::fieldLang($this->info['config']['grid']);
		return View::make('{class}.view',$this->data);
		
	}	
	
	function postSave( $id =0)
	{
		$rules = $this->validateForm();
		$validator = Validator::make(Input::all(), $rules);	
		if ($validator->passes()) {
			$data = $this->validatePost('{table}');
			$ID = $this->model->insertRow($data , Input::get('{key}'));
			// Input logs
			if( Input::get('{key}') =='')
			{
				$this->inputLogs("New Entry row with ID : $ID  , Has Been Save Successfull");
			} else {
				$this->inputLogs(" ID : $ID  , Has Been Changed Successfull");
			}
			// Redirect after save	
			return Response::json(array(
				'status'=>'success',
				'message'=> Lang::get('core.note_success')
				));	
											
		} else {
			$message = $this->validateListError(  $validator->getMessageBag()->toArray() );
			return Response::json(array(
				'message'	=> $message,
				'status'	=> 'error'
			));	
		}	
	
	}	
	

	function postCopy()
	{
		
	    foreach(DB::select("SHOW COLUMNS FROM {table}") as $column)
        {
			if( $column->Field != '{key}')
				$columns[] = $column->Field;
        }
		$toCopy = implode(",",Input::get('id'));
		
				
		$sql = "INSERT INTO {table} (".implode(",", $columns).") ";
		$sql .= " SELECT ".implode(",", $columns)." FROM {table} WHERE {key} IN (".$toCopy.")";
		DB::insert($sql);
		return Response::json(array(
			'status'=>'success',
			'message'=> Lang::get('core.note_success')
		));	
	}	
		
	
	public function postDestroy()
	{
		if($this->access['is_remove'] ==0) { echo SiteHelpers::alert('error',Lang::get('core.note_restric')); die; }		
		// delete multipe rows 
		if(!is_null(Input::get('id')))
		{
			$this->model->destroy(Input::get('id'));
			$this->inputLogs("ID : ".implode(",",Input::get('id'))."  , Has Been Removed Successfull");
			return Response::json(array(
				'status'=>'success',
				'message'=> SiteHelpers::alert('success',Lang::get('core.note_success_delete'))
			));
		} else {
			return Response::json(array(
				'status'=>'error',
				'message'=> Lang::get('core.note_error')
			));

		} 	
		
	}			
		
}