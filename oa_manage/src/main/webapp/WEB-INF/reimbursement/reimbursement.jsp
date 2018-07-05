<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/layui-v2.1.4/layui/common/base.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
	<title>用户统计</title>
</head>
<body>

<form class="layui-form" action="" target="nm_iframe">
	<blockquote class="layui-elem-quote">
	   	<div class="layui-form-item">
		    <label class="layui-form-label">统计时间：</label>
		    <div class="layui-input-inline" style="width: 100px;">
		   		<input type="text" id="startDate" autocomplete="off" class="layui-input" />
		    </div>
		    <div class="layui-form-mid">-</div>
		    <div class="layui-input-inline" style="width: 100px;">
		   		<input type="text" id="endDate" autocomplete="off" class="layui-input" />
		    </div>
	   		<button type="button" data-method="queryHandler" class="layui-btn" id="query">查询</button>
	   		<button type="reset" id="resetId" class="layui-btn layui-btn-primary">重置</button>
	   		<button class="layui-btn" class="layui-btn layui-btn-danger" id="add" >新增报销</button>
	    </div>
    </blockquote>
</form>
 

<!-- 设置表单容器 --> 
<table id="dateTable" lay-filter="demo"></table>

<!-- 设置审批页面 -->
<div style="display: none" id="detail" lay-filter="test22">
	<!-- <table id="activityDetail" lay-filter="activityDetail"></table> -->
	<form class="layui-form layui-form-pane" action="####" style="margin-right: 5%; margin-top: 10px;height: 500px"  id="itemAddForm">

		<div class="layui-form-item" pane>
			<label class="layui-form-label">用户名:</label>
			<div class="layui-input-block">
				<input type="text" id="userName"  name="userName"     autocomplete="off" class="layui-input" />
			</div>
		</div>
		
		<div class="layui-form-item" pane>
			<label class="layui-form-label">账号:</label>
			<div class="layui-input-block">
				<input type="text" id="account" autocomplete="off" class="layui-input" />
			</div>
			
		</div>
			<div class="layui-form-item" pane>
			<label class="layui-form-label">报销详情:</label>
			<div class="layui-input-block">
				<input type="text" id="reimbursement" autocomplete="off" class="layui-input" />
			</div>
		</div>

	<div class="layui-form-item" pane>
			<label class="layui-form-label">报销总金额:</label>
			<div class="layui-input-block">
				<input type="text" id="grossAmount" autocomplete="off" class="layui-input" />
			</div>
		</div>

		<div class="layui-form-item" pane>
			<label class="layui-form-label">开始时间:</label>
			<div class="layui-input-block">
				<input type="text" id="startTime" autocomplete="off" class="layui-input" />
			</div>
		</div>

		<div class="layui-form-item" pane>
			<label class="layui-form-label">结束时间:</label>
			<div class="layui-input-block">
				<input type="text" id="endTime" autocomplete="off" class="layui-input" />
			</div>
		</div>


		<!--
		<div class="layui-form-item" pane>
			<label class="layui-form-label">审批状态:</label>
			<div class="layui-input-block">
				<input type="text" id="approvalStatus" autocomplete="off"  class="layui-input" />
			</div>
		</div>-->
		 <div class="layui-form-item">
    <label class="layui-form-label">审批状态:</label>
    <div class="layui-input-block">
      <input type="checkbox" name="close" {{d.type=='1'?'checked':''}} id="approvalStatus" lay-skin="switch" lay-text="是|否" lay-filter="switchTest" value="0">
    </div>
  </div>
	
	


	</form>
</div>


<!-- 设置操作按钮 -->
<script type="text/html" id="barDemo">
	<a class="layui-btn layui-btn-mini" lay-event="edit">审批</a>

	<a class="layui-btn layui-btn-danger layui-btn-mini" lay-event="del">删除</a>
</script>

<script src="${basePath }/layui-v2.1.4/layui/jquery-2.1.1.min.js" type="text/javascript"></script>
<script src="${basePath }/layui-v2.1.4/layui/zoomove.min.js" type="text/javascript"></script>   
<script src="${basePath }/layui-v2.1.4/layui/layui.js?t=1506699022911"></script>
<script type="text/html" id="titleTpl2">
	{{#
		var fn = function(date){
			return date.substring(0,11);
		};
	}}
	{{# if(d.birthTime != '' ){ }}
		{{ fn(d.birthTime)  }}
	{{#  } else { }}
		d.birthTime
	{{#  } }}
</script>


<script>
var currentPage=1;
layui.use(['layedit', 'jquery','laydate', 'laypage', 'layer', 'table', 'carousel', 'upload', 'element'], function(){
	var $ = layui.jquery;  			//引用自身的JQuery
	var laydate = layui.laydate 		//日期
  	,laypage = layui.laypage 			//分页
  	,layer = layui.layer 				//弹层
  	,table = layui.table 				//表格
  	,carousel = layui.carousel 		//轮播
 	,upload = layui.upload 			//上传
 	,layedit = layui.layedit 			//文本审批器
 	,element = layui.element; 			//元素操作
 	var editorFirst;					//富文本审批器 全局变量!

 	
 	//================数据渲染到页面    方法一Start====================
 	function queryDynamic(){	
	table.render({//向后台发送数据 
		  elem: '#dateTable' 		//指定原始表格元素选择器（推荐id选择器）
		  ,height: 590 		 		//容器高度
		  ,page:true 		 		//开启分页 
		  ,even: true 				//开启隔行背景
		  ,method:'post'
		  ,request: {		 		//分页   设置分页名称
			  pageName: 'page' 		//页码的参数名称，默认：page
		 	 ,limitName: 'pageSize' //每页数据量的参数名，默认：limit
		  }
			  	  					//分页参数设置  	
	  	  ,limits:[10]
	  	  ,limit: 10 				//默认采用60	
		  ,response: {
			  statusName: 'code'  	//数据状态的字段名称，默认：code
			  ,statusCode: 200 		//成功的状态码，默认：0
			  ,msgName: 'msg'  		//状态信息的字段名称，默认：msg
			  ,countName: 'total' 	//数据总数的字段名称，默认：count
			  ,dataName: 'data' 	//数据列表的字段名称，默认：data
		  } 	
	 	  ,where:{queryRestraintJson:getQueryParam()}
	 	  ,url: js_path+'/userAuditl/queryDynamic'//查询的那个请求 
	 
	 	  ,cols:[[
				{field: 'userName', title: '用户名', width: 160, align:'center'}
				,{field: 'account', title: '账号', width: 160, align:'center'}
				,{field: 'reimbursement', title: '报销详情', width: 160, align:'center'}
			   ,{field: 'grossAmount', title: '报销总金额', width: 160, align:'center'}
			   ,{field: 'startTime', title: '开始时间', width: 160, align:'center'}
			   ,{field: 'endTime', title: '结束时间', width: 160, align:'center'}
			   ,{field: 'approvalStatus', title: '审批状态', width: 160, align:'center',templet:'#titleTpl'}

			   ,{fixed: 'right', width:160,height:80, align:'center',title:'操作',toolbar:'#barDemo'}
	 		    ]]
  	
	 	  ,done: function(res, curr, count){
	 		  //如果是异步请求数据方式，res即为你接口返回的信息。
	 		  //如果是直接赋值的方式，res即为：{code: 200, msg: "查询成功", total: 17, data: Array(10)} 
	 		  console.log(res);
	 		  //得到当前页码
	 		  console.log(curr);
	 		  //得到数据总量
	 		  console.log(count);
		  }
	}); 
 	}
 	//================数据渲染   end======================

		
	queryDynamic();
	

	$('#query').click(function(e){
		queryDynamic();
	});
	
	//新增按钮事件
	$('#add').click(function(e){
	   
        layer.open({
            type: 1
            ,skin: 'layui-layer-lan'//样式类名
            ,title: '新增报销'
            ,area: ['800px', '400px']// 宽高
            ,offset: '100px' 			//只定义top坐标，水平保持居中
            ,shade:['0.3','#000']
            ,maxmin: true//最大最小化。
            ,content:$('#detail')// 内容，content可传入的值是灵活多变的，不仅可以传入普通的html内容，还可以指定DOM，更可以随着type的不同而不同。
            ,btn: ['确认','取消']//弹出框里的确认，取 消
            ,yes: function(index,layero){//该回调携带两个参数，分别为当前层索引、当前层DOM对象。如：
                $.ajax({
                    type:"POST",
                    dataType: 'json',
                    url:js_path+'/userAuditl/add',
                  //getEntity()获取添加的信息转成json
                    data:{'json':JSON.stringify(getEntity())},
                    success: function(data) {
                    	debugger;
                    	console.log(data);
                        if(data.code == 200){
                            layer.msg('添加成功!', {icon: 6});
                            queryDynamic();
						}
                    }
                });
                layer.closeAll();
            }
        });
	     
	     
	     
        //日期选择器
        laydate.render({
            elem: '#startTime'
            ,type: 'date' //默认，可不填
        });
        
        //日期选择器
        laydate.render({
            elem: '#endTime'
            ,type: 'date' //默认，可不填
        });
       
    	//将日期直接嵌套在指定容器中
    	laydate.render({ 
    		elem: '#birthdateId'
    		,type: 'date'
    		
    	});

 
		queryDynamic();//=数据渲染 
	});
	
	//重置按钮事件
	$('#resetId').click(function(e){
		$('name').val("");
		$('integralStart').val("");
		$('integralEnd').val("");
		queryDynamic();
	});
		

	//监听工具条
	table.on('tool(demo)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
		var data = obj.data 		//获得当前行数据
		,layEvent = obj.event; 		//获得 lay-event 对应的值
		if(layEvent === 'edit'){//审批		
			 // 打开审批列表 
			 
			 //loading层
			//var indexWithdraw = layer.load(1, {
			//  shade: [0.1,'#fff'] //0.1透明度的白色背景
			//});
			 	queryWithdraw(data.userId,'3',function(){
				//layer.close(indexWithdraw);
            layer.open({//审批报销的弹出框 
                type: 1
                ,skin: 'demo-class'
                ,title: '审批报销'
                ,area: ['800px', '400px']
                ,offset: '100px' 			//只定义top坐标，水平保持居中
                ,shade:['0.3','#000']
                ,maxmin: true
                ,content:$('#withdrawContainer')
                ,btn: ['确认','取消']
                ,yes: function(index,layero){
                	
                    $.ajax({
                        type:"POST",
                        dataType: 'json',
                        url:js_path+'/Edit/reimburse',
                        data:{'id':data.id,'json':JSON.stringify(getEntity())},
                        success: function(data) {
                            if(data.code == 200){
                                layer.msg('修改成功!', {icon: 6});
                                queryDynamic();
							}
                        }
                    });
                    layer.closeAll();
                }
            });
			 	  });

        	//查询需要撤回的站内信表格
        	function queryWithdraw(userId,messageType,func){	
        		table.render({
        			  elem: '#withdrawTable' 		//指定原始表格元素选择器（推荐id选择器）
        			  ,height: 590 		 		//容器高度
        			  ,page:true 		 		//开启分页 
        			  ,even: true 				//开启隔行背景
        			  ,method:'post'
        			  ,request: {		 		//分页   设置分页名称
        				  pageName: 'page' 		//页码的参数名称，默认：page
        			 	 ,limitName: 'pageSize' //每页数据量的参数名，默认：limit
        			  }
        		,loading:false   //没办法此版本没有回掉
        				  	  					//分页参数设置  	
        		  	  ,limits:[10]
        		  	  ,limit: 10 				//默认采用60	
        			  ,response: {
        				  statusName: 'code'  	//数据状态的字段名称，默认：code
        				  ,statusCode: 200 		//成功的状态码，默认：0
        				  ,msgName: 'msg'  		//状态信息的字段名称，默认：msg
        				  ,countName: 'total' 	//数据总数的字段名称，默认：count
        				  ,dataName: 'data' 	//数据列表的字段名称，默认：data
        			  } 	
        		 	  ,where:{'userId':userId,'messageType':messageType}
        		 	  ,url: js_path+'/mail/querySystemMessage'
        		 	  //弹出框按钮 
        		 	  ,cols:[[
        				   {field: 'messageContent', title: '用户名', width: 215,align:'center'}
        				   ,{field: 'messageContent', title: '内容', width: 300,align:'center'}
        				   ,{fixed: 'right', width:215, align:'center',title:'操作',toolbar:'#editDemo'}
        		 		    ]]
        	  		  // 数据渲染完的回调   无论是异步请求数据，还是直接赋值数据，都会触发该回调.
        		 	  ,done: function(res, curr, count){
        		 		  //如果是异步请求数据方式，res即为你接口返回的信息。
        		 		  //如果是直接赋值的方式，res即为：{code: 200, msg: "查询成功", total: 17, data: Array(10)} 
        		 		  console.log(res);
        		 		  //得到当前页码
        		 		  console.log(curr);
        		 		  //得到数据总量
        		 		  console.log(count);
        		 		  if('function' == typeof func){
        		 			 func();
        		 		  }
        			  }
        		}); 
        	 	}	
        	form.on('switch(widthDraw)',function(data){
        		var id = ($(this).attr('data-id'));
        		layer.msg(id+'您正进行：'+ (this.checked ? '撤回' : '恢复')+'操作', {
        		      offset: '6px'
        		    });
        		
        		    layer.tips('温馨提示：请注意撤回后发送给微信端的站内信就无法读取', data.othis);
        		 // messageType=3表示点对点站内信
        			$.ajax({
        				type:"POST",
        		        dataType: 'json',
        		        url:js_path+'/mail/updateOne',
        			    data:{'id':id,'isNewuserTips':(this.checked ? '1' : '0')},		
        			    success: function(datas) {
        			    	layer.msg('更新成功!', {icon: 6});
        			    	//spotAndModuleHandler('10',data.userId);
        			    }
        			});
        		console.log(data.othis);
        	});
        	
            //日期选择器
             laydate.render({
                elem: '#date1'
                ,type: 'date' //默认，可不填
            });
            
        	 var active = {
     			    getCheckData: function(){ //获取选中数据
     			      var checkStatus = table.checkStatus('idTest')
     			      ,data = checkStatus.data;
     			     // layer.alert(JSON.stringify(data));
     			    //给详情页面赋值
     					$('#sendTo').html("给"+data.length+"人的站内信");
     			      var time = (new Date()).Format('yyyy-MM-dd hh:mm:ss');
     					form.render();
     			        // 打开详情页面
     			        layer.open({
     			            type: 1
     			            ,skin: 'demo-class'
     			            ,title: '站内信内容'
     			            ,area: ['800px', '220px']
     			            ,offset: '100px' 			//只定义top坐标，水平保持居中
     			            ,shade:['0.3','#000']
     			            ,maxmin: true
     			            ,content:$('#detail')
     			            ,btn: ['确认','取消']
     			            ,yes: function(index,layero){

     			            	var content = $('#message').val();
     			            	var arr = [];
     							for( var i = 0,m=data.length;i<m;i++ ){
     								var item = {};
     								item.messageContent = content;
     								item.messageType = '3';
     								item.userId = data[i].userId;
     								item.isNewuserTips = '0';
     								item.type = '0';
     								item.creatTime = time;
     								arr.push(item);
     							}
     							// messageType=3表示点对点站内信
     							$.ajax({
     								type:"POST",
     						        dataType: 'json',
     						        url:js_path+'/mail/sendSome',
     							    data:{'json':JSON.stringify(arr)},		
     							    success: function(datas) {
     							    	
     							    	for( var i = 0,m=data.length;i<m;i++ ){
     							    		
     							    		spotAndModuleHandler('10',data[i].userId);
     							    	}
     							    	if('function' == typeof func){
     							    		func();
     							    	}else{
     							    		layer.msg('发送成功!', {icon: 6});
     							    	}
     							    },error:function(e){
     							    	if('function' == typeof errorFunc){
     							    		errorFunc();
     							    	}else{
     							    		layer.msg('发送失败!', {icon: 6});
     							    	}
     							    }
     							    
     							});
     							layer.closeAll();
     							//queryDynamic();
     			                $('#message').val("");
     			            }
     			        });
     			        //日期选择器
     			        laydate.render({
     			            elem: '#date1'
     			            ,type: 'date' //默认，可不填
     			        });
     			      
     			    }
     	 			,widthDrawAll:function(){//撤回
     	 				table.render({
     	 					  elem: '#withdrawTable' 		//指定原始表格元素选择器（推荐id选择器）
     	 					  ,height: 590 		 		//容器高度
     	 					  ,page:true 		 		//开启分页 
     	 					  ,even: true 				//开启隔行背景
     	 					  ,method:'post'
     	 					  ,request: {		 		//分页   设置分页名称
     	 						  pageName: 'page' 		//页码的参数名称，默认：page
     	 					 	 ,limitName: 'pageSize' //每页数据量的参数名，默认：limit
     	 					  }
     	 				,loading:false   //没办法此版本没有回掉
     	 						  	  					//分页参数设置  	
     	 				  	  ,limits:[10]
     	 				  	  ,limit: 10 				//默认采用60	
     	 					  ,response: {
     	 						  statusName: 'code'  	//数据状态的字段名称，默认：code
     	 						  ,statusCode: 200 		//成功的状态码，默认：0
     	 						  ,msgName: 'msg'  		//状态信息的字段名称，默认：msg
     	 						  ,countName: 'total' 	//数据总数的字段名称，默认：count
     	 						  ,dataName: 'data' 	//数据列表的字段名称，默认：data
     	 					  } 	
     	 				 	  ,where:{'userId':'88','messageType':'4'}
     	 				 	  ,url: js_path+'/mail/querySystemMessage'
     	 				 	  //设置表头  进行数据渲染
     	 				 	  ,cols:[[
     	 						   {field: 'messageContent', title: '内容', width: 550,align:'center'}
     	 							
     	 						   ,{fixed: 'right', width:250, align:'center',title:'操作',toolbar:'#editDemo'}
     	 				 		    ]]
     	 			  		  // 数据渲染完的回调   无论是异步请求数据，还是直接赋值数据，都会触发该回调.
     	 				 	  ,done: function(res, curr, count){
     	 				 		  //如果是异步请求数据方式，res即为你接口返回的信息。
     	 				 		  //如果是直接赋值的方式，res即为：{code: 200, msg: "查询成功", total: 17, data: Array(10)} 
     	 				 		  console.log(res);
     	 				 		  //得到当前页码
     	 				 		  console.log(curr);
     	 				 		  //得到数据总量
     	 				 		  console.log(count);
     	 				 		layer.open({
     	 			                type: 1
     	 			                ,skin: 'demo-class'
     	 			                ,title: '群发的站内信内容'
     	 			                ,area: ['800px', '400px']
     	 			                ,offset: '100px' 			//只定义top坐标，水平保持居中
     	 			                ,shade:['0.3','#000']
     	 			                ,maxmin: true
     	 			                ,content:$('#withdrawContainer')
     	 			                ,btn: ['确认','取消']
     	 			                ,yes: function(index,layero){

     	 			    				layer.closeAll();
     	 			                }
     	 			            });
     	 					  }
     	 				}); 
     	 			}
     			    ,isAll: function(){ //群发所有人
     			    	var item = {};
     			    	item.realName="所有人"
     					item.userId = '88';//表示统一所有人的Id
     			    	sendMail(item,'4');
     			    }
     			  };
        	 		
        	  $('.demoTable .layui-btn').on('click', function(){
  			    var type = $(this).data('type');
  			    active[type] ? active[type].call(this) : '';
  			  });
        		function sendMail(data_bak,messageType, func,errorFunc){
        			//给详情页面赋值
        			$('#sendTo').html("给"+data_bak.realName+"的站内信");

        			form.render();
        	        // 打开详情页面
        	        layer.open({
        	            type: 1
        	            ,skin: 'demo-class'
        	            ,title: '站内信内容'
        	            ,area: ['800px', '220px']
        	            ,offset: '100px' 			//只定义top坐标，水平保持居中
        	            ,shade:['0.3','#000']
        	            ,maxmin: true
        	            ,content:$('#detail')
        	            ,btn: ['确认','取消']
        	            ,yes: function(index,layero){

        	            	var content = $('#message').val();
        					// messageType=3表示点对点站内信
        					$.ajax({
        						type:"POST",
        				        dataType: 'json',
        				        url:js_path+'/mail/send',
        					    data:{'userId':data_bak.userId,'content':content,'messageType':messageType},		
        					    success: function(datas) {
        					    	
        					    	if("3" == messageType)
        					    		spotAndModuleHandler('10',data_bak.userId);
        					    	else if("4" == messageType)
        					    		spotAndModuleHandler('11',data_bak.userId);
        					    	if('function' == typeof func){
        					    		func();
        					    	}else{
        					    		layer.msg('发送成功!', {icon: 6});
        					    	}
        					    },error:function(e){
        					    	if('function' == typeof errorFunc){
        					    		errorFunc();
        					    	}else{
        					    		layer.msg('发送失败!', {icon: 6});
        					    	}
        					    }
        					    
        					});
        					layer.closeAll();
        					//queryDynamic();
        	                $('#message').val("");
        	            }
        	        });
        	        //日期选择器
        	        laydate.render({
        	            elem: '#date1'
        	            ,type: 'date' //默认，可不填
        	        });
        		}	
        		
        		// 获取查询参数
        		function getQueryParam(){
        			//此处仅供测试，实际需要读取标签值
        			var t = new Object();
        			var invitationUserVo = new Object();
        			invitationUserVo.page=currentPage;
        			invitationUserVo.pageSize=10;
        			// 认证表，默认查询待审核状态的
        			t.idcard=$.trim($("#idcard").val());
        			t.phone=$.trim($("#phoneNumber").val());
        			t.userId = "1";//$.trim($("#status").val());'1'表示注册员工
        			invitationUserVo.t=t;
        			return JSON.stringify(invitationUserVo);
        		}
        		
        		/**
        		*moduleId 模块id
        		*/
        		function spotAndModuleHandler(moduleId,userId){
        			
        			$.ajax({
        				type:"POST",
        		        dataType: 'json',
        		        url:js_path+'/spotpush/queryModule',
        			    data:{'json':JSON.stringify({'moduleId':moduleId,'userId':userId})},		
        			    success: function(data) {
        			    	
        			    	//存在就更新
        			    	if(data.data&&data.data.length>0){
        			    		var item = data.data[0];
        			    		var timesOfBrowsing = parseInt(item.timesOfBrowsing);
        			    		$.ajax({
        	    					type:"POST",
        	    			        dataType: 'json',
        	    			        url:js_path+'/spotpush/updateModule',
        	    				    data:{'json':JSON.stringify({'id':item.id,'timesOfBrowsing':++timesOfBrowsing,'moduleId':moduleId,'userId':userId})},		
        	    				    success: function(data) {
        	    				    	
        	    				    }
        	    				});
        			    		
        			    	}else{//不存在就创建
        			    		$.ajax({
        	    					type:"POST",
        	    			        dataType: 'json',
        	    			        url:js_path+'/spotpush/addModule',
        	    				    data:{'json':JSON.stringify({'timesOfBrowsing':'1','moduleId':moduleId,'userId':userId})},		
        	    				    success: function(data) {
        	    				    	
        	    				    }
        	    				});
        			    	}
        			    	
        			    }
        			});
        		}
        		
        		
		}else if(layEvent == 'del'){
		    //打开一个询问框
            layer.confirm('确定要删除?删除后数据不可恢复！', {icon: 3, title:'提示'}, function(index){
            	  if(data.status == '1'){
                      layer.msg('该信息已经处理，不能删除。',{icon: 2});
                      layer.close(index);
                      return false;
                  }
                $.ajax({
                    type:"POST",
                    dataType: 'json',
                    url:js_path+'/userAuditl/delete',
                    data:{'id':data.id},
                    success: function(data) {
                        if(data.code == 200){
                            layer.msg('删除成功!!!', {icon: 6});
                            queryDynamic();
                        }
                    },
                });
                layer.close(index);
            });
		}
	});
	

//获取添加的信息放到对象里 
function getEntity(){
    var entity = new Object();
    entity.userName=$('#userName').val();
    entity.account=$('#account').val();
    entity.reimbursement=$('#reimbursement').val();
    entity.grossAmount= $("#grossAmount").val();
    entity.startTime= $("#startTime").val();
    entity.endTime = $("#endTime").val();
	entity.approvalStatus = $('#approvalStatus').val();
	entity.right=$('#right').val();
    return entity;
}

	//初始化开始时间
    laydate.render({
        elem: '#startDate'
        ,type: 'date'
        //,range: true //或 range: '~' 来自定义分割字符
    });
	//初始化结束时间
    laydate.render({
        elem: '#endDate'
        ,type: 'date'
        //,range: true //或 range: '~' 来自定义分割字符
    });

	
	// 获取查询参数
	function getQueryParam(){
		//此处仅供测试，实际需要读取标签值
		var t = new Object();
		var invitationUserVo = new Object();
		invitationUserVo.page=currentPage;
		invitationUserVo.pageSize=10;
		// 认证表，默认查询待审核状态的
		t.idcard=$.trim($("#idcard").val());
		t.phone=$.trim($("#phoneNumber").val());
		t.userId = $.trim($("#status").val());
		invitationUserVo.t=t;
		return JSON.stringify(invitationUserVo);
	}
});


</script>
<!--弹出来那个弹出框的操作 -->
<script id="editDemo" type="text/html">
<form class="layui-form ">
<div class="layui-form-item">
    <label class="layui-form-label">是否审批:</label>
    <div class="layui-input-block">
      <input type="checkbox" name="close" data-id="{{d.id}}" {{d.isNewuserTips=='1'?'checked':''}} id="typeInput" lay-skin="switch" lay-text="是|否" lay-filter="widthDraw" value="0">
    </div>
</form>
</script>

<!-- 第一步：编写模版。你可以使用一个script标签存放模板，如：
<script id="titleTpl" type="text/html">

      <input type="checkbox" name="close" {{d.type=='1'?'checked':''}} id="typeInput" lay-skin="switch" lay-text="是|否" lay-filter="switchTest" value="0">
 
</script>-->
<script type="text/html" id="titleTpl">
	{{# if(d.sex =='1'){ }}
		审批
	{{#  } else { }}
		未审批
	{{#  } }}
	</script>

</body>
<div id="withdrawContainer" style="display:none">
<table id="withdrawTable" lay-filter="withdraw"></table>
</div>
</html>