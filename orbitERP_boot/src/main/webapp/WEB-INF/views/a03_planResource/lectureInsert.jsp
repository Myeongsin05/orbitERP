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
#chatArea {
	height: 300px;
}

#text {
	width: 70%;
	margin-left: auto;
	margin-right: auto;
}

.input-group-text {
	width: 100%;
	background-color: linen;
	color: black;
	font-weight: bolder;
}

.input-group-prepend {
	width: 20%;
}

.input_value {
	display: flex;
	align-items: center;
	width: 35%;
}
</style>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    			searchStu()
    			//searchTch()
				var msg = "${msg}"
				if (msg != "") {
					if (!confirm(msg + "\n계속 등록하시겠습니까?")) {
						location.href = "lectureList"
					}
					$("form")[0].reset()
				}
				$("#schBtn").click(function(){ //학생 모달창 검색
					//$("[name=subject]").val($("[name=lec_code]").text());
					searchStu()
				})
				$("#schTBtn").click(function(){ //강사 모달창 검색
					searchTch()
				})
				$("[name=name],[name=final_degree]").keyup(function(){
			    	  if(event.keyCode==13) // 없으면 실시간으로 조회 처리해줌
			    	  searchStu()
			      })
				
				$("#insBtn").click(
						function() {
							if ($("[name=lec_name]").val() == "") {
								alert("강의명을 입력하세요")
								return;
							}
							if ($("[name=start_date]").val() == "") {
								alert("개강일자를 입력하세요")
								return;
							}
							if ($("[name=end_date]").val() == "") {
								alert("종강일자를 입력하세요")
								return;
							}
							if ($("[name=lec_num]").val() == "") {
								alert("강의실을 입력하세요")
								return;
							}
							if ($("[name=tuition_fee]").val() == ""
									|| isNaN($("[name=tuition_fee]").val())) {
								alert("강의료를 숫자로 입력하세요")
								return;
							}
							if ($("[name=textbook_fee]").val() == ""
									|| isNaN($("[name=textbook_fee]").val())) {
								alert("교재비를 숫자로 입력하세요")
								return;
							}
							if ($("[name=lec_content]").val() == "") {
								alert("강의내용을 입력하세요")
								return;
							}
							if (confirm("강의를 등록하시겠습니까?")) {
								$("#insLecture").submit()
							}
						})

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
						startDateInput.val("");
						endDateInput.val("");
					}
				}

				// 개강일자와 종강일자 input 요소에 change 이벤트 리스너 등록
				startDateInput.change(checkDateValidity);
				endDateInput.change(checkDateValidity);
				
			$("#insertStu").click(function(){
			    $("[name=lec_snum]").val(snoList.length);
			    $("#frm02")[0].reset() //검색값 리셋
			    searchStu() //다시 학생조회했을 때 전체출력
			    $("#stuModal").modal("hide");//모달 닫기
			    $(".modal-backdrop").remove();//뒷배경 제거
			});
			
			var lecCodeMapping = { // 강의 코드와 강사과목이 다른걸 맞춰주기 위해서
					  'KOR': '국어',
					  'ENG': '영어',
					  'MATH': '수학',
					  'PHY': '물리',
					  'BIO': '생물',
					  'JAVA': 'JAVA',
					  'JS': 'Javascript',
					  'C++': 'C++',
					  'PY': 'Python',
					  'C': 'C'
					  // 계속 추가 예정
					};
			$("#schTch").click(function(){
				var selectedSubject = lecCodeMapping[$("[name=lec_code]").val()];
				//등록페이지에서 받아온 강의코드를 mapping
				$("[name=subject]").val(selectedSubject);
				//form에 넣고
			    searchTch() 
				if($("[name=subject]").val()=="" || $("#tch tr").length === 0){
					if(confirm("해당과목 담당강사가 없습니다.\n강사등록을 하시겠습니까?")){
						location.href="empList";
						return;
					}
				}
				//검색
			});
		
});
			

function searchStu() {
    $.ajax({
        url: "/stuSch",
        data: $("#frm02").serialize(),
        dataType: "json",
        success: function (studentList) {
        	$("#totStu").text('총 학생 수 : '+studentList.length+'명')
            var stuhtml = "";
            $.each(studentList, function (idx, stu) {
            	stuhtml += "<tr ondblclick=\"location.href='detailStudent?sno=" + stu.sno + "'\">";
                stuhtml += "<td>" + stu.sno + "</td>"
                stuhtml += "<td>" + stu.name + "</td>"
                stuhtml += "<td>" + stu.birth + "</td>"
                stuhtml += "<td>" + stu.final_degree + "</td>"
                stuhtml += "<td>" + stu.phone + "</td>"
                stuhtml += "<td>" + stu.address + "</td>"
                stuhtml += '<td><button class="btn btn-success" type="button" onclick="addStu(\'' + stu.sno + '\',\'' + stu.name + '\',\'' + stu.final_degree + '\',\'' + stu.phone + '\')">등록</button></td>';
                stuhtml += "</tr>"
            })

            $("#stu").html(stuhtml);
        },
        error: function (err) {
            console.log(err)
        }
    });
}
function searchTch() {
    $.ajax({
        url: "/schTch",
        data: $("#frm01").serialize(),
        dataType: "json",
        success: function (data) {
            var stuhtml = "";
            $.each(data.teacherList, function (idx, tch) {
            	stuhtml += "<tr ondblclick=\"location.href='detailEmp?empno=" + tch.empno + "'\">";
                stuhtml += "<td>" + tch.empno + "</td>"
                stuhtml += "<td>" + tch.ename + "</td>"
                stuhtml += "<td>" + tch.subject + "</td>"
                stuhtml += "<td>" + tch.email + "</td>"
                stuhtml += '<td><button class="btn btn-success" type="button" onclick="addTch(\'' + tch.empno + '\',\'' + tch.ename + '\',\'' + tch.subject + '\')">등록</button></td>';
                stuhtml += "</tr>"
            })

            $("#tch").html(stuhtml);
        },
        error: function (err) {
            console.log(err)
        }
    });
}

function addTch(empno,ename,subject){
	$("[name=lec_teacher]").val(ename);
	$("#frm01")[0].reset() //검색값 리셋
	searchTch() //다시 강사조회했을 때 전체출력
	$("#tchModal").modal("hide");//모달 닫기
    $(".modal-backdrop").remove();//뒷배경 제거
}

var snoList=[] //등록처리된 sno들
function addStu(sno, name, final_degree,phone) {
	
	//이미 등록된 학생 중복X
	//snoList의 값들과 sno를 비교하는 코드
	if(snoList.includes(sno)){
		alert('이미 등록된 학생입니다.')
		return;
	}else{
    	snoList.push(sno)
	}
	
    var row = "";
    row += "<tr><td>" + sno + "</td>";
    row += "<td>" + name + "</td>";
    row += "<td>" + final_degree + "</td>";
    row += "<td>" + phone + "</td>";
    row += "<td><button class='btn btn-danger' type='button' onclick='deleteStu(this)'>삭제</button></td>";
    row += "</tr>";

    $("#add").append(row);
}

function deleteStu(button) {
	// 삭제 버튼을 클릭한 행을 찾아 삭제
    var deletedSno = $(button).closest("tr").find("td:first").text();
    $(button).closest("tr").remove();

    // snoList에서 해당 sno번호 삭제
    var index = snoList.indexOf(deletedSno);
    if (index !== -1) {
        snoList.splice(index, 1);
    }
}
</script>
<!-- DB테이블 플러그인 추가 -->
<link rel="stylesheet" href="${path}/a00_com/css/vendor.bundle.base.css">
<link rel="stylesheet"
	href="${path}/a00_com/vendor/datatables/dataTables.bootstrap4.css">
<link rel="stylesheet" type="text/css"
	href="${path}/a00_com/js/select.dataTables.min.css">
	
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
						<h1 class="h3 mb-0 text-gray-800">강의등록</h1>
					</div>
					<div class="card shadow mb-4">
						<div class="card-body">
							<div id="text">
								<form method="post" action="${path}/lectureInsert" id=insLecture>
									<div class="input-group mb-3">
										<div class="input-group-prepend">
											<span class="input-group-text  justify-content-center">
												강의코드</span>
										</div>
										<select class="custom-select" id="lecCodeSelect"
											name="lec_code">
											<option value="JAVA">JAVA</option>
											<option value="JS">Javascript</option>
											<option value="C">C</option>
											<option value="C++">C++</option>
											<option value="PY">Python</option>
											<option value="KOR">국어</option>
											<option value="ENG">영어</option>
											<option value="MATH">수학</option>
										</select>
									</div>
									<div class="input-group mb-3">
										<div class="input-group-prepend ">
											<span class="input-group-text  justify-content-center">
												강의명</span>
										</div>
										<input name="lec_name" class="form-control" type="text"/>
										<div class="input-group-prepend ">
											<span class="input-group-text  justify-content-center">
												강사명</span>
										</div>
										<div class="input_value">
											<input name="lec_teacher" class="form-control" type="text" readonly/> <input
												type="button" class="btn btn-dark" value="강사찾기"
												data-toggle="modal" data-target="#tchModal" id="schTch"/>
										</div>
									</div>
									<div class="input-group mb-3">
										<div class="input-group-prepend ">
											<span class="input-group-text  justify-content-center">
												개강일자</span>
										</div>
										<input type="date" name="start_date" class="form-control">
										<div class="input-group-prepend ">
											<span class="input-group-text  justify-content-center">
												종강일자</span>
										</div>
										<div class="input_value">
											<input type="date" name="end_date" class="form-control">
										</div>
									</div>
									<div class="input-group mb-3">
									    <div class="input-group-prepend ">
									        <span class="input-group-text  justify-content-center">
									            강의실
									        </span>
									    </div>
									    <input name="lec_num" class="form-control" type="text"/>
									    <div class="input-group-prepend ">
									        <span class="input-group-text  justify-content-center">
									            학생수
									        </span>
									    </div>
									    <div class="input_value">
									        <input name="lec_snum" class="form-control" readonly type="number"/> 
									        <input type="button" class="btn btn-dark" value="학생등록"
									            data-toggle="modal" data-target="#stuModal" id="schStu" />
									    </div>
									</div>
									<div class="input-group mb-3">
										<div class="input-group-prepend ">
											<span class="input-group-text  justify-content-center">
												강의료</span>
										</div>
										<input name="tuition_fee" class="form-control" type="number"/>
										<div class="input-group-prepend ">
											<span class="input-group-text  justify-content-center">
												교재비</span>
										</div>
										<div class="input_value">
											<input name="textbook_fee" class="form-control" type="number"/>
										</div>
									</div>
									<div class="input-group mb-3">
										<div class="input-group-prepend ">
											<span class="input-group-text  justify-content-center">
												강의내용</span>
										</div>
										<textarea id="chatArea" name="lec_content"
											class="form-control"></textarea>
									</div>
									<div style="text-align: right;">
										<input type="button" class="btn btn-info" value="등록"
											id="insBtn" />
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>

				<!-- /.container-fluid (페이지 내용 종료) -->
			</div>
			<!-- End of Main Content -->
			<!-- start 강사조회modal -->
			<div class="modal" id="tchModal" >
				<div class="modal-dialog modal-dialog-centered modal-lg" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title">강사등록</h5>
							<button type="button" class="close" data-dismiss="modal"
								aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
						<div class="card shadow mb-4">
						<div class="card-header py-3">
							<hr>
							<form id="frm01" class="form" method="post">
								<nav class="navbar navbar-expand-sm navbar-light bg-light">

									<input placeholder="강사명" name="ename" value="${schT.ename}"
										class="form-control mr-sm-2" /> 
									<select name="subject"  class="form-control mr-sm-2" >
										<option value="">담당과목</option>
										<c:forEach var="subject" items="${subjects}">
											<option>${subject}</option>
										</c:forEach>
									</select>
								<!-- <select class="form-control mr-sm-2" name="subject">									
										<option value="">담당과목</option>
										<option >JAVA</option>
										<option >국어</option>
										<option >수학</option>
										<option >영어</option>
									</select> -->
									<button class="btn btn-info" type="button" id="schTBtn">Search</button>
								</nav>
							</form>
						</div>
						<div class="card-body">
							<span>더블클릭시, 강사 상세정보 페이지로 이동합니다.</span>
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable3">
								  <col width="20%">
							      <col width="15%">
							      <col width="15%">
							      <col width="35%">
							      <col width="15%">
									<thead>
										<tr>
											<th>강사번호</th>
											<th>이름</th>
											<th>담당과목</th>
											<th>이메일</th>
											<th>선택</th>
										</tr>
									</thead>
									<tbody id="tch">
									</tbody>
								</table>
							</div>
						</div>
					</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-dismiss="modal">닫기</button>
						</div>
					</div>
				</div>
			</div>
		</div>
			
			<!-- start 학생조회modal -->
			<div class="modal" id="stuModal" >
				<div class="modal-dialog modal-dialog-centered modal-lg" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title">학생등록</h5>
							<button type="button" class="close" data-dismiss="modal"
								aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
						<div class="card shadow mb-4">
						<div class="card-header py-3">

							<hr>
							<form id="frm02" class="form" method="post">
								<nav class="navbar navbar-expand-sm navbar-light bg-light">

									<input placeholder="학생명" name="name" value="${sch.name}"
										class="form-control mr-sm-2" /> 
									<select class="form-control mr-sm-2" name="final_degree">									
										<option value="">학년 선택</option>
										<option value="초등">초등</option>
										<option value="중등">중등</option>
										<option value="고등">고등</option>
										<option value="성인">성인</option>
									</select> 
									<button class="btn btn-info" type="button" id="schBtn">Search</button>
								</nav>
								<div class="input-group mt-3 mb-0">
									<span class="input-group-text" id="totStu"></span>
								</div>
							</form>
						</div>
						<div class="card-body">
							<span>더블클릭시, 학생 상세정보 페이지로 이동합니다.</span>
							<div class="table-responsive">
								<table class="table table-bordered" id="dataTable1">
								  <col width="8%">
							      <col width="10%">
							      <col width="18%">
							      <col width="15%">
							      <col width="15%">
							      <col width="25%">
							      <col width="9%">
									<thead>
										<tr>
											<th>학생번호</th>
											<th>이름</th>
											<th>생년월일</th>
											<th>학년</th>
											<th>전화번호</th>
											<th>주소</th>
											<th>선택</th>
										</tr>
									</thead>
									<tbody id="stu">
									</tbody>
								</table>
							</div>
							<hr>
							<div class="table-responsive">
								<h5>수강학생</h5>
								<table class="table table-bordered" id="dataTable2">
								<col width="15%">
							    <col width="20%">
							    <col width="25%">
							    <col width="25%">
							    <col width="15%">
									<thead>
										<tr>
											<th>학생번호</th>
											<th>이름</th>
											<th>학년</th>
											<th>전화번호</th>
											<th>삭제</th>
										</tr>
									</thead>
									<tbody id="add">
									</tbody>
								</table>
							</div>
						</div>
					</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary"
								data-dismiss="modal">닫기</button>
							<button type="button" class="btn btn-primary" id="insertStu">학생등록</button>
						</div>
					</div>
				</div>
			</div>
		</div>
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
	<script src="${path}/a00_com/vendor/jquery-easing/jquery.easing.min.js"></script>

	<!-- Custom scripts for all pages-->
	<script src="${path}/a00_com/js/sb-admin-2.min.js"></script>
	
	<!-- 추가 plugins:js -->
	<script src="${path}/a00_com/vendor/js/vendor.bundle.base.js"></script>
	<script src="${path}/a00_com/vendor/datatables/jquery.dataTables.js"></script>
	<script
		src="${path}/a00_com/vendor/datatables/dataTables.bootstrap4.js"></script>
	<script src="${path}/a00_com/js/dataTables.select.min.js"></script>
</body>
</html>