<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Form_L.aspx.cs" Inherits="Design_Lab_Form_L" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">

        $(function () {
            $('#FrmDate').change(function () {
                ChkDate();

            });

            $('#ToDate').change(function () {
                ChkDate();

            });
            chkSelectAll();
        });

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnReport.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnReport.ClientID %>').removeAttr('disabled');

                    }
                }
            });
        }
      
        function chkSelectAll() {
            var status = $('#<%= chkDisease.ClientID %>').is(':checked');
            if (status == true) {
                $('.chkAll input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAll input[type=checkbox]").attr("checked", false);
            }
        }
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
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align:center">
            <div class="col-md-24">
                <b>Laboratory Surveillance Report</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
                </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                SearSearch Criteria
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                    <div class="col-md-3">
                             <label class="pull-left">
                                 Patient Type
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlPatientType" runat="server" ClientIDMode="Static"></asp:DropDownList>
                         </div>
                    <div class="col-md-3">
                             <label class="pull-left">
                                 From Date
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                              <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" Width="144px" TabIndex="7"
                                    ToolTip="Select From Date"></asp:TextBox>
                                <cc1:CalendarExtender   ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                                </cc1:CalendarExtender>
                         </div>
                     <div class="col-md-3">
                    <label class="pull-left">
                                 To Date
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                              <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" Width="144px" TabIndex="7"
                                    ToolTip="Select From Date"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="ToDate">
                                </cc1:CalendarExtender>
                         </div>
                </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><asp:CheckBox  ID="chkDisease" runat="server" Text="Disease" ClientIDMode="Static" onclick="chkSelectAll()" Checked="true" /></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkDiseaseList" CssClass="chkAll" runat="server" RepeatDirection="Horizontal" RepeatColumns="4" ClientIDMode="Static"></asp:CheckBoxList>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left"><asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre :&nbsp;" /></label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                           <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>

                    </div>
                    </div>
                <div class="col-md-1"></div>

            </div>
    
             </div>
        <div class="POuter_Box_Inventory" >
                 <div class="row" style="text-align: center;">
                    <div class="col-md-24">
                     <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Text="Report" OnClick="btnReport_Click" />
                        </div>
                 </div>
    </div>
        </div>
</asp:Content>


