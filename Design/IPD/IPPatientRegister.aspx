<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPPatientRegister.aspx.cs"
    Inherits="Reports_IPD_IPPatientRegister" MasterPageFile="~/DefaultHome.master" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript" >
        $(document).ready(function () {
            $('#txtFromDate').change(function () {
                ChkDate();
            });

            $('#txtToDate').change(function () {
                ChkDate();
            });

        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                         $('#btnBinSearch').attr('disabled', 'disabled');

                     }
                     else {
                         $('#<%=lblMsg.ClientID %>').text('');
                         $('#btnBinSearch').removeAttr('disabled');

                     }
                 }
             });

        }

        function checkAllCentre() {
            var status = $('#<%= chkAllCentre.ClientID %>').is(':checked');

                   if (status == true) 
                       $('.chkAllCentreCheck input[type=checkbox]').attr("checked", "checked");
                   
                   else 
                       $(".chkAllCentreCheck input[type=checkbox]").attr("checked", false);
                   
               }
               function chkCentreCon() {
                   if (($('#<%= chkCentre.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkCentre.ClientID %>  input[type=checkbox]').length)) 
                $('#<%= chkAllCentre.ClientID %>').attr("checked", "checked");
            
            else 
                $('#<%= chkAllCentre.ClientID %>').attr("checked", false);
            
               }
        function checkAllCustomField() {
            var status = $('#<%= chkcustomfieldApply.ClientID %>').is(':checked');

             if (status == true)
                 $('.customfieldApply input[type=checkbox]').attr("checked", "checked");

             else
                 $(".customfieldApply input[type=checkbox]").attr("checked", false);

         }
        function checkFieldList() {
             if (($('#<%= chkfieldlist.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkfieldlist.ClientID %>  input[type=checkbox]').length))
                       $('#<%= chkcustomfieldApply.ClientID %>').attr("checked", "checked");

                   else
                       $('#<%= chkcustomfieldApply.ClientID %>').attr("checked", false);

               }



    </script>
   
    <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScripManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>IPD Patient Register</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                    <div class="col-md-5">
                        <label class="pull-left">Type</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-10">
                     <asp:RadioButtonList ID="rdoReportType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Text="Total Bills" Value="1" />
                                <asp:ListItem Text="OutStanding On Patient Side" Value="2" />
                                <asp:ListItem Text="OutStanding On Hospital Side" Value="3" />
                            </asp:RadioButtonList>
                    </div>
                     </div>
                    <div class="row">
                         <div class="col-md-5">
                        <label class="pull-left"><asp:CheckBox ID="chkFinalBill" runat="server"></asp:CheckBox>IPD No.</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <asp:TextBox ID="txtIPDNo" runat="server"   MaxLength="10"></asp:TextBox>
                    </div>
                    <div class="col-md-6">
                            <label class="pull-right"  style="color:blue">if checkbox checked Final Details Show</label>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Admission From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <asp:TextBox ID="txtFromDate" runat="server" Width="170px" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="Fromdatecal" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-5">
                            <label class="pull-left">Admission To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                                <asp:TextBox ID="txtToDate" runat="server" Width="170px" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="ToDatecal" TargetControlID="txtToDate" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                     <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left"><asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" /></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                                 <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" 
RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                         </div>
                </div>
                <div class="col-md-1"></div>

            </div>
                
          <div id="divcustomfield" runat="server">
                    <div class="Purchaseheader">
                  Coustom Report Fields Apply<asp:CheckBox ID="chkcustomfieldApply" runat="server" onclick="checkAllCustomField()" ClientIDMode="Static"/>
            </div>
              <table>
                  <tr>
                      <td>Search By Name :&nbsp;</td>
                      <td><asp:TextBox ID="txtSearch" runat="server" ClientIDMode="Static" Width="400px" onkeyup="SearchCheckbox(this,'#chkfieldlist')"></asp:TextBox></td>
                  </tr>
              </table>
                <table style="overflow:scroll;height:100px;width:100%">
                    <tr>
                        <td style="text-align:left">
                             <div style="width:100%; text-align: left;border:groove" class="scrollankur">
                            <asp:CheckBoxList ID="chkfieldlist" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" RepeatColumns="7" CssClass="customfieldApply" onclick="checkFieldList()">
                                <asp:ListItem Value="CentreName">CentreName</asp:ListItem>
                                <asp:ListItem Value="MRNo">MRNo</asp:ListItem><asp:ListItem Value="IPDNo">IPDNo</asp:ListItem>
                                <asp:ListItem Value="DateOfAdmit">DateOfAdmit</asp:ListItem><asp:ListItem Value="TimeOfAdmit">TimeOfAdmit</asp:ListItem>
                                <asp:ListItem Value="PatientName">PatientName</asp:ListItem><asp:ListItem Value="Age">Age</asp:ListItem>
                                <asp:ListItem Value="Address">Address</asp:ListItem><asp:ListItem Value="Country">Country</asp:ListItem>
                                <asp:ListItem Value="ContactNo">ContactNo</asp:ListItem><asp:ListItem Value="Relation">Relation</asp:ListItem>
                                <asp:ListItem Value="RelationName">RelationName</asp:ListItem><asp:ListItem Value="AdmittedRoomType">AdmittedRoomType</asp:ListItem>
                                <asp:ListItem Value="AdmittedBedNo">AdmittedBedNo</asp:ListItem><asp:ListItem Value="MainConsultant">MainConsultant</asp:ListItem>
                                <asp:ListItem Value="NetAmount">NetAmount</asp:ListItem><asp:ListItem Value="ReceiveAmt_After_BillDate">ReceiveAmt_After_BillDate</asp:ListItem>
                                <asp:ListItem Value="DischargedRoomType">DischargedRoomType</asp:ListItem><asp:ListItem Value="DischargedBedNo">DischargedBedNo</asp:ListItem>
                                <asp:ListItem Value="BillingRoomType">BillingRoomType</asp:ListItem><asp:ListItem Value="MainConsultant1">MainConsultant1</asp:ListItem>
                                <asp:ListItem Value="SecondaryConsultant">SecondaryConsultant</asp:ListItem><asp:ListItem Value="AdmittedBy">AdmittedBy</asp:ListItem>
                                 <asp:ListItem Value="Relation1">Relation1</asp:ListItem><asp:ListItem Value="RelationName1">RelationName1</asp:ListItem>
                                <asp:ListItem Value="MLC_No">MLC_No</asp:ListItem><asp:ListItem Value="Admission_Type">Admission_Type</asp:ListItem>
                                <asp:ListItem Value="Source">Source</asp:ListItem><asp:ListItem Value="ParentPanel">ParentPanel</asp:ListItem>
                                <asp:ListItem Value="Panel">Panel</asp:ListItem><asp:ListItem Value="VulnerableType">VulnerableType</asp:ListItem>
                                <asp:ListItem Value="CurrentStatus">CurrentStatus</asp:ListItem><asp:ListItem Value="Remarks">Remarks</asp:ListItem>
                                <asp:ListItem Value="DischargeType">DischargeType</asp:ListItem><asp:ListItem Value="DischargedBy">DischargedBy</asp:ListItem>
                                <asp:ListItem Value="AdmissionCancelDate">AdmissionCancelDate</asp:ListItem><asp:ListItem Value="AdmissionCancelledBy">AdmissionCancelledBy</asp:ListItem>
                                <asp:ListItem Value="AdmissionCancelReason">AdmissionCancelReason</asp:ListItem><asp:ListItem Value="DischargeCancelDate">DischargeCancelDate</asp:ListItem>
                                <asp:ListItem Value="DischargedCancelledBy">DischargedCancelledBy</asp:ListItem><asp:ListItem Value="DischargeCancelReason">DischargeCancelReason</asp:ListItem>
                                <asp:ListItem Value="BillNoCancelled">BillNoCancelled</asp:ListItem><asp:ListItem Value="BillDateOfBillNoCancelled">BillDateOfBillNoCancelled</asp:ListItem>
                                <asp:ListItem Value="BillCancellationDate">BillCancellationDate</asp:ListItem><asp:ListItem Value="BillCancelUserID">BillCancelUserID</asp:ListItem>
                                <asp:ListItem Value="BillNo">BillNo</asp:ListItem><asp:ListItem Value="BillDate">BillDate</asp:ListItem><asp:ListItem Value="BillGeneratedBy">BillGeneratedBy</asp:ListItem>
                                <asp:ListItem Value="BillAmt">BillAmt</asp:ListItem><asp:ListItem Value="ServiceTaxAmt">ServiceTaxAmt</asp:ListItem><asp:ListItem Value="RoundOff">RoundOff</asp:ListItem>
                                <asp:ListItem Value="TotalBillAmt">TotalBillAmt</asp:ListItem><asp:ListItem Value="DiscountOnBill">DiscountOnBill</asp:ListItem><asp:ListItem Value="ItemWiseDiscount">ItemWiseDiscount</asp:ListItem>
								<asp:ListItem Value="TotalDiscount">TotalDiscount</asp:ListItem><asp:ListItem Value="NetAmount1">NetAmount1</asp:ListItem><asp:ListItem Value="Deposit_AsOn_BillDate">Deposit_AsOn_BillDate</asp:ListItem>
                                <asp:ListItem Value="Refund_AsOn_BillDate">Refund_AsOn_BillDate</asp:ListItem><asp:ListItem Value="ReceiveAmt_AsOn_BillDate">ReceiveAmt_AsOn_BillDate</asp:ListItem><asp:ListItem Value="OutStanding_AsOn_BillDate">OutStanding_AsOn_BillDate</asp:ListItem>
                                <asp:ListItem Value="OutStanding_AsOn_BillDate">OutStanding_AsOn_BillDate</asp:ListItem><asp:ListItem Value="Deposit_After_BillDate">Deposit_After_BillDate</asp:ListItem><asp:ListItem Value="Refund_After_BillDate">Refund_After_BillDate</asp:ListItem>
                           		<asp:ListItem Value="ReceiveAmt_After_BillDate1">ReceiveAmt_After_BillDate1</asp:ListItem><asp:ListItem Value="TDS">TDS</asp:ListItem><asp:ListItem Value="Deduction_Acceptable">Deduction_Acceptable</asp:ListItem>
                                <asp:ListItem Value="Deduction_NonAcceptable">Deduction_NonAcceptable</asp:ListItem><asp:ListItem Value="DeductionReason">DeductionReason</asp:ListItem><asp:ListItem Value="WriteOff">WriteOff</asp:ListItem>
                                <asp:ListItem Value="CreditAmt">CreditAmt</asp:ListItem><asp:ListItem Value="WriteOffRemarks">WriteOffRemarks</asp:ListItem><asp:ListItem Value="DebitAmt">DebitAmt</asp:ListItem>
                                <asp:ListItem Value="OutStanding_After_BillDate">OutStanding_After_BillDate</asp:ListItem><asp:ListItem Value="ClaimNo">ClaimNo</asp:ListItem><asp:ListItem Value="PolicyNo">PolicyNo</asp:ListItem>
                      			<asp:ListItem Value="CardNo">CardNo</asp:ListItem><asp:ListItem Value="CardHolderName">CardHolderName</asp:ListItem><asp:ListItem Value="RelationWith_holder">RelationWith_holder</asp:ListItem>
                                <asp:ListItem Value="FileNo">FileNo</asp:ListItem><asp:ListItem Value="PanelAppRemarks">PanelAppRemarks</asp:ListItem><asp:ListItem Value="PanelApprovedAmt">PanelApprovedAmt</asp:ListItem>
                                <asp:ListItem Value="PanelApprovalDate">PanelApprovalDate</asp:ListItem><asp:ListItem Value="DiscountOnBillReason">DiscountOnBillReason</asp:ListItem><asp:ListItem Value="PanelApprovedAmt">DiscountOnBillReason</asp:ListItem>
                                <asp:ListItem Value="BillingRemarks">BillingRemarks</asp:ListItem><asp:ListItem Value="DiscApprovedBy">DiscApprovedBy</asp:ListItem><asp:ListItem Value="BillingStatus">BillingStatus</asp:ListItem>
                            </asp:CheckBoxList></div>
                      </td>
                    </tr>
                </table>
        </div>      </div>
        <div class="POuter_Box_Inventory" style="vertical-align: middle; text-align: center">
                <asp:Button ID="btnBinSearch" runat="server" Text="Report" CssClass="ItDoseButton" ClientIDMode="Static" OnClick="btnBinSearch_Click" />
        </div>
    </div>






</asp:Content>
