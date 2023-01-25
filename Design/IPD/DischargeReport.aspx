<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DischargeReport.aspx.cs"
    Inherits="Design_IPD_DischargeReport" MasterPageFile="~/DefaultHome.master" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });
            $('#ucToDate').change(function () {
                ChkDate();
            });
        });
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
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                         $('#<%=btnSearch.ClientID %>,#<%=btnExport.ClientID %>').attr('disabled', 'disabled');
                         $('#<%=grdDetail.ClientID %>').hide();
                     }
                     else {
                         $('#<%=lblMsg.ClientID %>').text('');
                         $('#<%=btnSearch.ClientID %>,#<%=btnExport.ClientID %>').removeAttr('disabled');
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

    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>&nbsp;Patient Discharged List </b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkAllCentre" ClientIDMode="Static" runat="server" onclick="checkAllCentre();" Text="Centre" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()" RepeatColumns="7" ClientIDMode="Static"
                                RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist" runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="row">
                       
                         <div class="col-md-3">
                            <label class="pull-left">
                            From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calucDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucFromDate"></cc1:CalendarExtender>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                            To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                         <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calToDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucToDate"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                CssClass="ItDoseButton" ClientIDMode="Static" />
            <asp:Button ID="btnExport" runat="server" Text="Export To Excel" CssClass="ItDoseButton"
                OnClick="btnExport_Click" Visible="False" ClientIDMode="Static" />
            <asp:Button ID="btnOpenOffice" runat="server" Text="Export To OpenOffice" CssClass="ItDoseButton"
                OnClick="btnOpenOffice_Click" Visible="False" Style="display: none" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Panel ID="pnl" runat="server" Height="490" ScrollBars="Auto">
                <asp:GridView ID="grdDetail" runat="server" CssClass="GridViewStyle">
                </asp:GridView>
            </asp:Panel>
            &nbsp;
        </div>
    </div>
</asp:Content>
