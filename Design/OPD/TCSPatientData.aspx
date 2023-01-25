<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TCSPatientData.aspx.cs" Inherits="Design_OPD_TCSPatientData" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <div id="Pbody_box_inventory">
              <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
              <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>TCS Patient Migration</b><br />
           <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
           <div class="POuter_Box_Inventory">
                      <div class="Purchaseheader">
                Search Option
            </div> 
                  <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                              UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtUHID" data-title="Enter UHID No." autocomplete="off" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Patient Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtPatientName" data-title="Enter Patient Name" autocomplete="off" />
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">Visit Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlvisittype">
                                <option value="0">All</option>
                                <option value="OP">OP</option>
                                <option value="IP">IP</option>
                                <option value="EOP">EOP</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><input type="checkbox" id="chkdatebclear" /> From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" data-title="Select From Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" data-title="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               <input type="checkbox" id="chkdobclear"  /> Date Of Birth
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="txtDOB" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="txtDOB">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row"  style="text-align:center">
                        <input type="button" id="btnSearch" value="Search" onclick="PatientLabSearch()" />
                    </div>
                </div></div></div>
         	<div class="POuter_Box_Inventory" >
                   <div class="Purchaseheader">
                Visit Details
            </div><div id="PagerDiv1" style="display:none;background-color:white;width:99%;padding-left:7px;"  >

              </div>
                 <div class="row">
				<div  style="overflow:auto;max-height:350px" id="divSampleDDetails" class="col-md-24">
                     <table style="width:100%;border-collapse:collapse"   id="tb_ItemList" class="GridViewStyle">
                    <tr id="header">
                        <td class="GridViewHeaderStyle" style="width:30px" >S.No.</td>
                        <td class="GridViewHeaderStyle" style="width:30px">MergeID</td>
                        <td class="GridViewHeaderStyle" style="width:120px">OLD UHID</td>
                        <td class="GridViewHeaderStyle" style="width:120px">New UHID</td>
                        <td class="GridViewHeaderStyle" style="width:300px">Patient Name</td>
                        <td class="GridViewHeaderStyle" style="width:80px">Visit Date</td>
                        <td class="GridViewHeaderStyle" style="width:150px">Patient Identifier</td>
                        <td class="GridViewHeaderStyle" style="width:100px">Visit Type</td> 
                        <td class="GridViewHeaderStyle" style="width:100px">Visit ID</td>    
                        <td class="GridViewHeaderStyle" style="width:30px">View</td>
                    </tr>
                </table>
				</div>
			</div>
     </div></div>
    <div id="MapUHID" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 500px;max-width:80%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeMergeUHID()"   aria-hidden="true">&times;</button>
				<h4 class="modal-title">Map UHID</h4>
               
			</div>
			<div class="modal-body">
                <div class="row">
                     <div  class="col-md-8">
                           <label class="pull-left">OLD UHID</label>
                         <b class="pull-right">:</b>
                     </div>
                     <div  class="col-md-15">
                         <b><span id="spnolduhid"></span></b>
					 </div>
                </div>
				 <div class="row">
					 <div  class="col-md-8">
						  <label class="pull-left"> Merge UHID    </label>
						  <b class="pull-right">:</b>
					 </div>
					 <div  class="col-md-15">
						  <input type="text" id="txtNewUHID" maxlength="8"  />
					 </div>
              </div>

				<div style="text-align:center" class="row">
					   <button type="button"  onclick="$mergeuhid($('#txtNewUHID').val(),$('#spnolduhid').text())">MAP UHID</button>
				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
         <script type="text/javascript">
             var checkcolour = function (el, st)
             {
                 var row = $(el).closest('tr');
                 if(st == 1)
                     $(row).addClass('selectedRow');
                 else
                     $(row).removeClass('selectedRow');
             }
             $(function () {
                
                 $('input').keyup(function () {
                     if (event.keyCode == 13)
                         if ($(this).val() != "")
                             PatientLabSearch();
                 });
             });
             function getsearchdata() {
                 var dataPLO = new Array();
                 dataPLO[0] = $('#txtUHID').val();
                 dataPLO[1] = $('#txtPatientName').val();
                 dataPLO[2] = $('#ddlvisittype').val();
                 if ($('#chkdatebclear').is(':checked')) {
                     dataPLO[3] = $('#FrmDate').val();
                     dataPLO[4] = $('#ToDate').val();
                 }
                 else {
                     dataPLO[3] = "";
                     dataPLO[4] = "";
                 }
                 if ($('#chkdobclear').is(':checked'))
                     dataPLO[5] = $('#txtDOB').val();
                 else
                     dataPLO[5] = "";
                 return dataPLO;
             }
             function PatientLabSearch() {
                 var barcodeno = "";
                 var searchdata = getsearchdata();
                 $('#tb_ItemList tr').slice(1).remove();
                 $.blockUI();
                 $.ajax({
                     url: "TCSPatientData.aspx/SearchPatient",
                     data: JSON.stringify({ searchdata: searchdata }),
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         var responseData = JSON.parse(result.d);
                         if (!responseData.status) {
                             $.unblockUI();
                             modelAlert(responseData.message, function () {
                                 $('#testcount').html('0');
                                 $('#PagerDiv1').html('');
                                 $('#PagerDiv1').hide();
                             });
                             return;
                         }
                         else {
                             TestData = responseData.data;
                             for (var i = 0; i < TestData.length; i++) {

                                 var mydata = '<tr style="cursor:pointer" onmouseover="checkcolour(this,1)" onmouseout="checkcolour(this,0)" ondblclick="ViewDocument(\'' + TestData[i].FileName + '\')">';
                                 mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                                 if (barcodeno != TestData[i].UHID) {
                                     mydata += '<td class="GridViewLabItemStyle" style="text-align:center">';
                                     mydata += '<img src="../../Images/edit.png" style="pointer:cursor" onclick="MergeUHID(\'' + TestData[i].UHID + '\')" /></td>';
                                     mydata += '<td class="GridViewLabItemStyle"><b>' + TestData[i].UHID + '</b></td>';
                                     mydata += '<td class="GridViewLabItemStyle"><b>' + TestData[i].NewPatientID + '</b></td>';
                                     mydata += '<td class="GridViewLabItemStyle"><b>' + TestData[i].PatientName + '</b></td>';
                                     mydata += '<td class="GridViewLabItemStyle"><b>' + TestData[i].VisitDate + '</b></td>';
                                     mydata += '<td class="GridViewLabItemStyle" id="td_BarcodeNo">' + TestData[i].BillingNumber + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle">' + TestData[i].VisitType + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle">' + TestData[i].VisitID + '</td>';
                                 }
                                 else {
                                     mydata += '<td class="GridViewLabItemStyle"></td>';
                                     mydata += '<td class="GridViewLabItemStyle"></td>';
                                     mydata += '<td class="GridViewLabItemStyle"></td>';
                                     mydata += '<td class="GridViewLabItemStyle"></td>';
                                     mydata += '<td class="GridViewLabItemStyle"><b>' + TestData[i].VisitDate + '</b></td>';
                                     mydata += '<td class="GridViewLabItemStyle">' + TestData[i].BillingNumber + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle">' + TestData[i].VisitType + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle">' + TestData[i].VisitID + '</td>';
                                 }
                                 mydata += '<td class="GridViewLabItemStyle" style="text-align:center">';
                                 mydata += '<img src="../../Images/view.gif" style="pointer:cursor" onclick="ViewDocument(\'' + TestData[i].FileName + '\')" /></td>';

                                 mydata += '</td>';
                                 mydata += "</tr>";
                                 $('#tb_ItemList').append(mydata);
                                 
                                // MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                                 barcodeno = TestData[i].UHID;
                             }
                             $('#divSampleDDetails').customFixedHeader();
                             $('#PagerDiv1').show();
                         }
                         $.unblockUI();
                     },
                     error: function (xhr, status) {
                         $.unblockUI();
                         window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
             }
             ViewDocument = function (url) {
                 var url1 = "\\TCSPatientFile\\ConsolidatedReports\\" + url;
                 window.open("../Lab/ViewFile.aspx?FileUrl=" + url1 + "&Extension=pdf&DocumentType=TCS");
             }


             function $mergeuhid(newuhid, olduhid) {
                 if (olduhid == "") {
                     modelAlert("Kindly Refresh The Page");
                     return;
                 }
                 //C0023671
                 if (newuhid.length != 8) {
                     modelAlert("Please Enter The Correct UHID");
                     return;
                 }
                 serverCall('TCSPatientData.aspx/MergeUHID', { newuhid: newuhid, olduhid: olduhid }, function (response) {
                     var responseData = JSON.parse(response);
                     modelAlert(responseData.response, function () {
                         if (responseData.status) {
                             $closeMergeUHID();
                             PatientLabSearch();
                         }
                     });
                 });
             }
             function MergeUHID(oldUHID) {
                 $('#spnolduhid').text(oldUHID);
                 $('#MapUHID').showModel();
             }

             $closeMergeUHID = function () {
                 $('#txtNewUHID').val('');
                 $('#spnolduhid').text('');
                 $('#MapUHID').hideModel();
             }
         </script>
      <style type="text/css">
         .selectedRow {
              background-color: aqua;
          }
           </style>
</asp:Content>

