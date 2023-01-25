<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="CreditDebitNoteReport.aspx.cs" Inherits="Design_common_CreditDebitNoteReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <div id="Pbody_box_inventory">
        <ajax:scriptmanager ID="ScriptManager1" runat="server">
        </ajax:scriptmanager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Credit-Debit Note Report </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                               Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio"  name="g" id="rbdOpd" />OPD
                            <input type="radio"  name="g"  id="rbtIpd" />IPD
                             <input type="radio"  name="g"  id="rbtEmg" />EMG
                            <input type="radio" checked="checked" name="g"  id="rbdAll" />All
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bill No. 
                            </label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <input type="text" id="txtBillNo" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                             UHID 
                            </label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">  
                          <input type="text" value="" id="txtUHID"  />
                          </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                               CR./DR. Note Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <select id="ddlCreditDebitNoteType">
                               <option value="0">ALL</option>
                                <option value="ltd.Rate<0">Credit Note On Rate</option>
                                <option value="ltd.TotalDiscAmt>0"style="display:none">Credit Note On Discount</option>
                                <option value="ltd.Rate>0" >Debit Note On Rate</option>
                                <option value="ltd.TotalDiscAmt<0" style="display:none">Debit Note On Discount</option>
                           </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date 
                            </label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select From Date"
                                TabIndex="1"></asp:TextBox>
                            <cc1:calendarextender ID="Fromdatecal" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:calendarextender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                   To Date
                            </label>
                            <b class="pull-right">:</b>
                    </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static" ToolTip="Click To Select To Date"
                                TabIndex="2"></asp:TextBox>
                            <cc1:calendarextender ID="ToDatecal" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:calendarextender>
                        </div>
                    </div>
                    <div class="row">
                       
                        <div class="col-md-3" style="display:none">
                              <label class="pull-left">
                                 Report Format
                              </label>
                            <b class="pull-right">:</b>
                         </div>
                        <div class ="col-md-5" style="display:none">
                               <input type="radio" name="e" checked="checked" id="rbdExcel" value="Excel" />Excel
                              <input type="radio" id="rbdPDF"  name="e" value="PDF" />PDF
                        </div>
                        <div class="col-md-3">
                              <label class="pull-left">
                                  Report Type
                              </label>
                            <b class="pull-right">:</b>
                         </div>
                        <div class ="col-md-5">
                               <input type="radio" name="r" id="rdbDetailed" value="D" />Detail
                              <input type="radio" id="rdbsummary" checked="checked" name="r" value="PDF" />Summary
                        </div>
                      </div>
                    <div class="row">
                        <div class="col-md-3">
                             <label class="pull-left">
                          <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" onclick="checkAllCentre();" runat="server"  />
                            Centre
                            </label>
                              <b class="pull-right">:</b>
                          </div>
                        <div class="col-md-12">
                                <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                                </asp:CheckBoxList>
                         </div>
                    </div>
           </div>
            </div> 
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-12">
                    <asp:Button Style="display:none" ID="btnPreview" runat="server" Text="Report" 
                CssClass="ItDoseButton"  ToolTip="Click To Open report" TabIndex="4" />
                    <input type="button" class="ItDoseButton" id="btnPreview1" style="float:right" value="Report" onclick="CreditDebitReport()" />
                    </div>
                 <div class="col-md-4">
                      </div>
                 <div class="col-md-4">
                    </div>
                </div>
        </div>
     </div>
    <script type="text/javascript">
        $(function () {
        });
        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

            if (status == true) {
                $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
            }
        }
        function chkCentreCon() {
            if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            }
        }
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        $('#btnPreview').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnPreview').removeAttr('disabled');
                    }
                }
            });

        }
        function CreditDebitReport() {
            debugger;
            var optionValCenterID = "";
            var CRDRType = $("#ddlCreditDebitNoteType").val();
            var chkAllCentre = $("#chkAllCentre").val();
            var fromDate = $("#ucFromDate").val();
            var ToDate = $("#ucToDate").val();
            var BillNo = $("#txtBillNo").val();
            var UHIDNo = $("#txtUHID").val();
            var value = "";
            var GetType = "";
            var ReportType = "";
            if ($("#rbdOpd").is(":checked")) {
                value = "OPD";
            }
            if ($("#rbtIpd").is(":checked")) {
                value = "IPD";
            }
            if ($("#rbtEmg").is(":checked")){
                value = "EMG";
            }
            if ($("#rbdAll").is(":checked")) {
                value = "All";
            }
            if ($("#rbdExcel").is(":checked")) {
                GetType = "Excel";
            }
            if ($("#rbdPDF").is(":checked")) {
                GetType = "Pdf";
            }
            if (chkAllCentre == "") {
                $("#chkAllCentre").css('border-color', 'firebrick').focus();
                $("#chkAllCentre").keyup(function () {
                    $(this).css('border-color', '#dddddd');
                });
                return false;
            }
            var checkedCentreCount = $('#chkCentre input[type=checkbox]:checked').length;
            if (checkedCentreCount == 0) {
                $('#<%=lblMsg.ClientID%>').text('Please Select Centre');
                return false;
            }
            else {
                
                for (i = 0; i < checkedCentreCount; i++) {
                    var chkid = "#chkCentre_" + i;
                    if (optionValCenterID == "")
                        optionValCenterID = "'" + $(chkid).val() + "'";
                    else
                        optionValCenterID += ",'" + $(chkid).val() + "'";
                }
            }
            if ($("#rdbDetailed").is(":checked")) {
                ReportType = "D";
            }
            if ($("#rdbsummary").is(":checked")) {
                ReportType = "S";
            }
            $.ajax({
                url: "CreditDebitNoteReport.aspx/CreditDebitNote",
                data: '{fromDate:"' + fromDate + '",toDate:"' + ToDate + '",CRDRType:"' + CRDRType + '",value:"' + value + '",CenterID:"' + optionValCenterID + '",GetType:"' + GetType + '",BillNo:"' + BillNo + '",UHIDNo:"' + UHIDNo + '",ReportType:"' + ReportType + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var item = jQuery.parseJSON(response.d);
                    if (item == "1") {
                        window.open('../../Design/common/Commonreport.aspx');
                    }
                    else if (item == "2") {
                        window.open('../../Design/common/ExportToExcel.aspx');
                    }
                    else {
                        modelAlert("No Record Found");
                    }
                }
            })
        }
        $(function () {
            $('input').keyup(function () {
                if (event.keyCode == 13)
                    CreditDebitReport();
            });
        })
    </script>
</asp:Content>

