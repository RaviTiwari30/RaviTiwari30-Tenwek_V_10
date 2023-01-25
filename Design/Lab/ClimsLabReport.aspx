<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ClimsLabReport.aspx.cs" Inherits="Design_Lab_ClimsLabReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div id="Pbody_box_inventory">
              <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
              <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Clims Lab Result</b><br />
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
                               Barcode No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtBarcodeNo" data-title="Enter Barcode No." autocomplete="off" />
                        </div>
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
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
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
                         
                        </div>
                        <div class="col-md-5">
                         <input type="button" id="btnSearch" value="Search" onclick="PatientLabSearch()" />
                        </div>
                    </div></div></div></div>
         	<div class="POuter_Box_Inventory" >
                   <div class="Purchaseheader">
                Visit Details
            </div><div id="PagerDiv1" style="display:none;background-color:white;width:99%;padding-left:7px;">

              </div>
                 <div class="row">
				<div  style="overflow:auto;max-height:350px" id="divSampleDDetails" class="col-md-24">
                     <table style="width:100%;border-collapse:collapse"   id="tb_ItemList" class="GridViewStyle">
                    <tr id="header">
                        <td class="GridViewHeaderStyle" style="width:30px" >S.No.</td>
                        <td class="GridViewHeaderStyle" style="width:100px">Barcode No.</td>
                        <td class="GridViewHeaderStyle" style="width:120px">UHID</td>
                        <td class="GridViewHeaderStyle" style="width:50px">Type</td>
                        <td class="GridViewHeaderStyle" style="width:100px">Date/Time</td>                   
                        <td class="GridViewHeaderStyle" style="width:300px">Patient Name</td>
                        <td class="GridViewHeaderStyle" style="width:30px">View</td>
                    </tr>
                </table>
				</div>
			</div>
     </div></div>
         <script type="text/javascript">
             $(function () {
                 $('input').keyup(function () {
                     if (event.keyCode == 13)
                         if ($(this).val() != "")
                             PatientLabSearch();
                 });
             });
             function getsearchdata() {
                 var dataPLO = new Array();
                 dataPLO[0] = $('#txtBarcodeNo').val();
                 dataPLO[1] = $('#txtUHID').val();
                 dataPLO[2] = $('#txtPatientName').val();
                 dataPLO[3] = $('#FrmDate').val();
                 dataPLO[4] = $('#ToDate').val();
                 return dataPLO;
             }
             function PatientLabSearch() {
                 var barcodeno = "";
                 var searchdata = getsearchdata();
                 $('#tb_ItemList tr').slice(1).remove();
                //     $.blockUI();
                 $.ajax({
                     url: "ClimsLabReport.aspx/SearchPatient",
                     data: JSON.stringify({ searchdata: searchdata }),
                     type: "POST", // data has to be Posted    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         var responseData = JSON.parse(result.d);
                         if (!responseData.status) {
                           //    $.unblockUI();
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
                               
                                 var mydata = "<tr id='" + TestData[i].ACC_ID + "' >";
                                 mydata += '<td class="GridViewLabItemStyle" >' + parseInt(i + 1) + '</td>';
                                 if (barcodeno != TestData[i].ACC_ID) {
                                     mydata += '<td class="GridViewLabItemStyle">' + TestData[i].ACC_ID + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle">' + TestData[i].CLNT_PTNT_ID + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle" id="td_BarcodeNo"><b>' + TestData[i].CLIENT + '</b></td>';
                                     mydata += '<td class="GridViewLabItemStyle">' + TestData[i].ACC_DT + '</td>';
                                     mydata += '<td class="GridViewLabItemStyle"><b>' + TestData[i].PTNT_NM + '</b></td>';
                                 }
                                 else {
                                     mydata += '<td class="GridViewLabItemStyle"></td>';
                                     mydata += '<td class="GridViewLabItemStyle"></td>';
                                     mydata += '<td class="GridViewLabItemStyle"></td>';
                                     mydata += '<td class="GridViewLabItemStyle"></td>';
                                     mydata += '<td class="GridViewLabItemStyle"></td>';
                                 }
                                 mydata += '<td class="GridViewLabItemStyle" style="text-align:center">';
                                 mydata += '<img src="../../Images/view.gif" style="pointer:cursor" onclick="ViewDocument(\'' + TestData[i].CLIENT + "\\\\" + TestData[i].File_Name + '\')" /></td>';
                                 mydata += '</td>';
                                 mydata += "</tr>";
                                 $('#tb_ItemList').append(mydata);
                                 $('#divSampleDDetails').customFixedHeader();
                                 MarcTooltips.add('[data-title]', '', { position: 'up', align: 'left', mouseover: true });
                                 barcodeno = TestData[i].ACC_ID;
                             }
                             $('#PagerDiv1').show();
                         }
                       //    $.unblockUI();
                     },
                     error: function (xhr, status) {
                       //    $.unblockUI();
                         window.status = status + "\r\n" + xhr.responseText;
                     }
                 });
             }
             ViewDocument = function(url) {
                 var url1 = "\\LABINVESTIGATION\\CLIMSDocuments\\"+ url;
                 window.open("ViewFile.aspx?FileUrl=" + url1 + "&Extension=pdf");
             }
         </script>
</asp:Content>

