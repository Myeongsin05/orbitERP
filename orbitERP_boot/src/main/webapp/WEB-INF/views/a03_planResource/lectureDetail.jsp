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
<%--
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<script src="https://developers.google.com/web/ilt/pwa/working-with-the-fetch-api" type="text/javascript"></script>
 --%>
 <style>
 #chatArea{
	height:300px;
}
#text{

width:70%;
	 margin-left: auto;
    margin-right: auto;
}
.input-group-text{width:100%;background-color:linen;
		color:black;font-weight:bolder;}
.input-group-prepend{width:20%;}
.input_value {
    display: flex;
    align-items: center;
    width: 35%;
}
 </style>
<!-- jQuery -->
<script src="${path}/a00_com/jquery-3.6.0.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
	    // 개강일자와 종강일자 input 요소를 가져옴
	    var startDateInput = $("input[name='start_date']");
	    var endDateInput = $("input[name='end_date']");
	
	    // input 요소의 값이 변경될 때마다 체크하는 함수
	    function checkDateValidity() {
	      // input 요소의 값 가져오기
	      var startDate = new Date(startDateInput.val());
	      var endDate = new Date(endDateInput.val());
	
	      // 개강일자가 종강일자보다 늦을 때
	      if (startDate > endDate) {
	        // 경고 알림창 표시
	        alert("개강일자는 종강일자보다 빨라야 합니다!");
	        // 현재 입력값 초기화
	        startDateInput.val("${lecture.start_date}");
	        endDateInput.val("${lecture.end_date}");
	      }
	    }
	
	    // 개강일자와 종강일자 input 요소에 change 이벤트 리스너 등록
	    startDateInput.change(checkDateValidity);
	    endDateInput.change(checkDateValidity);
	    
	$("#uptBtn").click(function(){
			if($("[name=lec_name]").val()==""){
				alert("강의명을 입력하세요")
				return;
			}
			if($("[name=start_date]").val()==""){
				alert("개강일자를 입력하세요")
				return;
			}
			if($("[name=end_date]").val()==""){
				alert("종강일자를 입력하세요")
				return;
			}
			if($("[name=lec_num]").val()==""){
				alert("강의실을 입력하세요")
				return;
			}
			if($("[name=tuition_fee]").val()==""||
					isNaN($("[name=tuition_fee]").val())){
				alert("강의료를 숫자로 입력하세요")
				return;
			}
			if($("[name=textbook_fee]").val()==""||
					isNaN($("[name=textbook_fee]").val())){
				alert("교재비를 숫자로 입력하세요")
				return;
			}
			if($("[name=lec_content]").val()==""){
				alert("강의내용을 입력하세요")
				return;
			}
			if(confirm("수정하시겠습니까?")){
	        $("form").attr("action", "lectureUpdate");
	        $("form").submit();
		}
		
	})
	$("#delBtn").click(function(){
		if(confirm("${lecture.lec_code}${lecture.lecno}를 삭제하시겠습니까?")){
			$("form").attr("action", "lectureDelete");
	        $("form").submit();
		}
	
	})
	
	var msg = "${msg}"
	if(msg!=""){
		alert(msg)
		if(msg="삭제완료"){
			location.href="lectureList"
		}
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
				<div class="container-fluid">
					<div
						class="d-sm-flex align-items-center justify-content-between mb-4">
						<h1 class="h3 mb-0 text-gray-800">[${lecture.lec_code}${lecture.lecno}]
							상세정보</h1>
					</div>
					<div class="card shadow mb-4">
						<div class="card-body">
							<div id="text">
							<form>
							<div class="input-group mb-3">
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										강의코드</span>
								</div>
								<input name="lec_code" class="form-control"
									value="${lecture.lec_code}" readonly/>
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center" >
										강의번호</span>
								</div>
								<div class="input_value">
								<input name="lecno" class="form-control"
									value="${lecture.lecno}" readonly/>
								</div>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										강의명</span>
								</div>
								<input name="lec_name" class="form-control"
									value="${lecture.lec_name}" />
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										강사명</span>
								</div>
								<div class="input_value">
								<input name="lec_teacher" class="form-control"
									value="${lecture.lec_teacher}" />
									<input type="button" class="btn btn-dark" value="강사조회" id="find" />
									</div>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										개강일자</span>
								</div>
								<input type="date" name="start_date" class="form-control"
									value="${lecture.start_date}" />
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										종강일자</span>
								</div>
								<div class="input_value">
								<input type="date" name="end_date" class="form-control"
									value="${lecture.end_date}" />
									</div>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										강의실</span>
								</div>
								<input name="lec_num" class="form-control"
									value="${lecture.lec_num}" />
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										학생수</span>
								</div>
								<div class="input_value">
								<input name="lec_snum" class="form-control" value="${lecture.lec_snum}" />
								<input type="button" class="btn btn-dark" value="학생조회" id="find" />
								</div>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										강의료</span>
								</div>
								<input name="tuition_fee" class="form-control"
									value="${lecture.tuition_fee}"/>
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										교재비</span>
								</div>
								<div class="input_value">
								<input name="textbook_fee" class="form-control"
									value="${lecture.textbook_fee}" />
								</div>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend ">
									<span class="input-group-text  justify-content-center">
										강의내용</span>
								</div>
								<textarea id="chatArea" name="lec_content" class="form-control">${lecture.lec_content}</textarea>
							</div>
							<div style="text-align: right;">
								<input type="button" class="btn btn-success" value="수정" id="uptBtn" />
								<input type="button" class="btn btn-danger" value="삭제" id="delBtn" /> 
								<input type="button" class="btn btn-dark" value="알림보내기" id="mainBtn" />
							</div>
							</form>
						</div>
						</div>
						</div>
					</div>

					<!-- /.container-fluid (페이지 내용 종료) -->
				</div>
				<!-- End of Main Content -->

				<!-- Footer -->
				<footer class="sticky-footer bg-white">
					<div class="container my-auto">
						<div class="copyright text-center my-auto">
							<span>Copyright &copy; Your Website 2021</span>
						</div>
					</div>
				</footer>
				<!-- End of Footer -->

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
		<script
			src="${path}/a00_com/vendor/jquery-easing/jquery.easing.min.js"></script>

		<!-- Custom scripts for all pages-->
		<script src="${path}/a00_com/js/sb-admin-2.min.js"></script>
</body>
</html>