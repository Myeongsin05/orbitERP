<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath }" />
<fmt:requestEncoding value="utf-8" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>:: Orbit ERP ::</title>
<link href="${path}/a00_com/img/logo.svg" rel="icon" type="image/x-icon" />
<!-- DB테이블 플러그인 추가 -->
<link rel="stylesheet" href="${path}/a00_com/css/vendor.bundle.base.css">
<link rel="stylesheet"
	href="${path}/a00_com/vendor/datatables/dataTables.bootstrap4.css">
<link rel="stylesheet" type="text/css"
	href="${path}/a00_com/js/select.dataTables.min.css">
<%--
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<script src="https://developers.google.com/web/ilt/pwa/working-with-the-fetch-api" type="text/javascript"></script>
 --%>
<!-- jQuery -->
<script src="${path}/a00_com/jquery-3.6.0.js"></script>

<script type="text/javascript">
	window.addEventListener("resize",function(){
	$("#chatMessageArea>div").width(
			$("#chatArea").width()-5)

	$(document).ready(function() {
		var wsocket = new WebSocket(
			"ws:localhost:5050/chat"	
		)
		
		wsocket.onopen = function(evt){
			console.log(evt)
			
			wsocket.send("${emem.auth}"+"님이 접속하셨습니다!")
		}
		wsocket.onmessage = function(evt){
			// 서버에서 push 접속한 모든 client에 전송..
			revMsg(evt.data) // 메시지 처리 공통 함수 정의				
		}
		
		function revMsg(msg){
			// 보내는 메시지는 오른쪽
			// 받는 메시지는 왼쪽 정렬 처리 : 사용자아이디:메시지 내용
			var alignOpt = "left"
			var msgArr = msg.split(":") // 사용자명:메시지 구분 하여 처리..
			var sndId = msgArr[0] // 보내는 사람 메시지 id
			if($("#id").val()==sndId){ 
				// 보내는 사람과 받는 사람의 아이디 동일:현재 접속한 사람이 보낸 메시지 
				alignOpt = "right"
				msg = msgArr[1] // 받는 사람 아이디 생략 처리
			}
			var msgObj = $("<div></div>").text(msg).attr("align",
					alignOpt).css("width",$("#chatArea").width())
			$("#chatMessageArea").append(msgObj);
			
			// 스크롤링 처리..
			// 1. 전체 해당 데이터의 높이를 구한다.
			// 2. 포함하고 있는 부모 객체(#chatArea)에서
			//    스크롤 기능 메서드로 스크롤되게 처리한다. scrollTop()
			var height = parseInt($("#chatMessageArea").height())
			mx += height+20
			$("#chatArea").scrollTop(mx)

		}
		var mx = 0;
		$("#sndBtn").click(function(){
			sendMsg()	
		})
		$("#msg").keyup(function(){
			if(event.keyCode==13){
				sendMsg()
			}
		})
		function sendMsg(){
			wsocket.send($("#id").val()+":"+$("#msg").val())
			$("${emem.auth}").val("")			
		}
	});
	
	
</script>

<!-- Custom fonts for this template-->
<link href="${path}/a00_com/vendor/fontawesome-free/css/all.min.css"
	rel="stylesheet" type="text/css">
<!-- 
    기존 font
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">
    -->
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100;300;400;500;700;900&display=swap"
	rel="stylesheet">

<!-- Custom styles for this template-->
<link href="${path}/a00_com/css/sb-admin-2.min.css" rel="stylesheet">
<link href="${path}/a00_com/css/custom-style.css" rel="stylesheet">
</head>
<style>
.frm {
	margin: auto;
}

#chatArea {
	width: 100%;
	height: 500px;
	overflow-y: scroll;
	text-align: left;
	
	margin: auto;
	padding-right: 15px;
}

.frogfeet{
	height: 3%;
}

</style>
<body id="page-top">

	<!-- Page Wrapper -->
	<div id="wrapper">

		<!-- Sidebar -->
		<%@ include file="/WEB-INF/views/a00_module/a02_sliderBar.jsp"%>
		<!-- End of Sidebar -->

		<!-- Content Wrapper -->
		<div id="content-wrapper" class="d-flex flex-column">

			<!-- Main Content -->
			<div id="content">
				<!-- Topbar  -->
				<%@ include file="/WEB-INF/views/a00_module/a03_topBar.jsp"%>
				<!-- End of Topbar -->
				<!-- Begin Page Content (여기서부터 페이지 내용 입력) -->

				<div class="col-xl-4 frm" id="frm"> <!-- 메신저 박스의 width는 여기에서 관리 -->
					<div class="card shadow mb-4">
						<!-- Card Header - Dropdown -->
						<div
							class="card-header py-3 d-flex flex-row align-items-center justify-content-center">
							<h6 class="m-0 font-weight-bold text-primary">ORBIT MESSANGER</h6>
						</div>
						<!-- Card Body -->
						<div class="card-body">

							<div id="chatArea" style="overflow-x: hidden"
								class="input-group-append">
								<div id="chatMessageArea"></div>
							</div>
							<br>
							<div class="input-group-append">
							<input type="text" id="msg" class="form-control"
								placeholder="메시지 입력" /> <input type="button" id="sndBtn"
								class="btn btn-success" value="전송" />
							</div>
						</div>
					</div>
				</div>



			</div>
			<!-- Content Row -->


			<!-- End of Main Content -->

			

		</div>
		<!-- End of Content Wrapper -->

	</div>
	<!-- End of Page Wrapper -->

	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded" href="#page-top"> <i
		class="fas fa-angle-up"></i>
	</a>
	<!-- Logout Modal-->
	<%@ include file="/WEB-INF/views/a00_module/a08_logout_modal.jsp"%>

	<!-- Bootstrap core JavaScript-->
	<script src="${path}/a00_com/vendor/jquery/jquery.min.js"></script>
	<script
		src="${path}/a00_com/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Core plugin JavaScript-->
	<script src="${path}/a00_com/vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for all pages-->
	<script src="${path}/a00_com/js/sb-admin-2.min.js"></script>

	<!-- Page level plugins -->
	<script src="${path}/a00_com/vendor/chart.js/Chart.min.js"></script>

	<!-- Page level custom scripts -->
	<script src="${path}/a00_com/js/demo/chart-area-demo.js"></script>
	<script src="${path}/a00_com/js/demo/chart-pie-demo.js"></script>
</body>
</html>