<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/static/common/common.jsp" %>
<!DOCTYPE html>
<HTML>
<HEAD>
	<TITLE>Jquery_zTree树-v3.5</TITLE>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	
	<link rel="stylesheet" href="<%=basePath %>/static/ztree/css/metroStyle/metroStyle.css"/>
	<script src="${basePath }/static/ztree/jquery.ztree.all.min.js"></script>
	
	
	<SCRIPT type="text/javascript">
		
		var setting = {
			check: {
				enable: true
			},
			data: {
				simpleData: {
					enable: true
				}
			}
		};

		var zNodes =[
			{ id:1, pId:0, name:"随意勾选 1", open:true},
			{ id:11, pId:1, name:"随意勾选 1-1", open:true},
			{ id:111, pId:11, name:"随意勾选 1-1-1"},
			{ id:112, pId:11, name:"随意勾选 1-1-2"},
			{ id:12, pId:1, name:"随意勾选 1-2", open:true},
			{ id:121, pId:12, name:"随意勾选 1-2-1"},
			{ id:122, pId:12, name:"随意勾选 1-2-2"},
			{ id:2, pId:0, name:"随意勾选 2", checked:true, open:true},
			{ id:21, pId:2, name:"随意勾选 2-1"},
			{ id:22, pId:2, name:"随意勾选 2-2", open:true},
			{ id:221, pId:22, name:"随意勾选 2-2-1", checked:true},
			{ id:222, pId:22, name:"随意勾选 2-2-2"},
			{ id:23, pId:2, name:"随意勾选 2-3"}
		];
		
		
		var code;
		
		function setCheck() {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
			py = $("#py").attr("checked")? "p":"",
			sy = $("#sy").attr("checked")? "s":"",
			pn = $("#pn").attr("checked")? "p":"",
			sn = $("#sn").attr("checked")? "s":"",
					
			type = { "Y":py + sy, "N":pn + sn};
			
			
			zTree.setting.check.chkboxType = type;
			
			showCode('setting.check.chkboxType = { "Y" : "' + type.Y + '", "N" : "' + type.N + '" };');
		}
		
	 	function showCode(str) {
			if (!code) code = $("#code");
			code.empty();
			code.append("<li>"+str+"</li>");
		} 
		
		
		$(document).ready(function(){
			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			
		 	setCheck();
			$("#py").bind("change", setCheck);
			$("#sy").bind("change", setCheck);
			$("#pn").bind("change", setCheck);
			$("#sn").bind("change", setCheck); 
		});
		//-->
	</SCRIPT>
	
</HEAD>

<BODY>
<h1>勾选操作</h1>
<h6></h6>
<div class="content_wrap">
	<div class="zTreeDemoBackground left">
		<ul id="treeDemo" class="ztree"></ul>
	</div>
	
	
	<div class="right">
		<ul class="info">
		
			<!-- 
			<li class="title"><h2>1、setting 配置信息说明</h2>
				<ul class="list">
				<li class="highlight_red">使用 checkbox，必须设置 setting.check 中的各个属性，详细请参见 API 文档中的相关内容</li>
				<li><p>父子关联关系：<br/>
						被勾选时：<input type="checkbox" id="py" class="checkbox first" checked /><span>关联父</span>
						<input type="checkbox" id="sy" class="checkbox first" checked /><span>关联子</span><br/>
						取消勾选时：<input type="checkbox" id="pn" class="checkbox first" checked /><span>关联父</span>
						<input type="checkbox" id="sn" class="checkbox first" checked /><span>关联子</span><br/>
						<ul id="code" class="log" style="height:20px;"></ul></p>
				</li>
				</ul>
			</li>
			<li class="title"><h2>2、treeNode 节点数据说明</h2>
				<ul class="list">
				<li class="highlight_red">1)、如果需要初始化默认节点被勾选，请设置 treeNode.checked 属性，详细请参见 API 文档中的相关内容</li>
				<li class="highlight_red">2)、如果某节点禁用 checkbox，请设置 treeNode.chkDisabled 属性，详细请参见 API 文档中的相关内容 和 'chkDisabled 演示'</li>
				<li class="highlight_red">3)、如果某节点不显示 checkbox，请设置 treeNode.nocheck 属性，详细请参见 API 文档中的相关内容 和 'nocheck 演示'</li>
				<li class="highlight_red">4)、如果更换 checked 属性，请参考 API 文档中 setting.data.key.checked 的详细说明</li>
				<li>5)、其他请参考 API 文档中 treeNode.checkedOld / getCheckStatus / check_Child_State / check_Focus 的详细说明</li>
				</ul>
			</li>
			
			 -->
		</ul>
	</div>
</div>
</BODY>
</HTML>