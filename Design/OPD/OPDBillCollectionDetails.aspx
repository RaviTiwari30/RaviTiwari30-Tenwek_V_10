<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="OPDBillCollectionDetails.aspx.cs" Inherits="Design_OPD_OPDBillCollectionDetails" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            $('#<%= chkAllCentre.ClientID %>').attr('checked', true);
            checkAllCentre();
            $('#chkSelectAllPanel').change(function () {

                if ($('#chkSelectAllPanel').prop('checked') == true) {

                    $("INPUT[id^='chkListPanel']").prop('checked', 'checked');
                }
                else {

                    $("INPUT[id^='chkListPanel']").removeAttr('checked');
                }

            });
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
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Bill Collection Detail</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">                   
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date"
                                TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtFromDate_CalendarExtender" runat="server" TargetControlID="txtFromDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date"
                                TabIndex="2" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="txtToDate_CalendarExtender" runat="server" TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtUHID" runat="server" CssClass="ItDoseTextinputText" ToolTip="Enter IPD No"></asp:TextBox>
                        </div>
                    </div>
                </div>
            </div>
            <div style="text-align: center">
                <table>
                    <tr>
                        <td style="text-align: right; width: 49%">Search By Panel Name :&nbsp;</td>
                        <td>
                            <asp:TextBox ID="txtSearch" runat="server" ClientIDMode="Static" Width="225px" onkeyup="SearchCheckbox(this,'#chkListPanel');"></asp:TextBox>
                        </td>
                        <td></td>
                    </tr>
                </table>
                <Ajax:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <table style="text-align: left; width: 100%; border-collapse: collapse">
                            <tr>
                                <td style="text-align: left; width: 8%; border-left-style: solid; border-left-color: inherit; border-left-width: medium; border-right-style: none; border-right-color: inherit; border-right-width: medium; border-top-style: solid; border-top-color: inherit; border-top-width: medium; border-bottom-style: solid; border-bottom-color: inherit; border-bottom-width: medium;">
                                    <asp:CheckBox ID="chkSelectAllPanel" runat="server" Text="Panel" ClientIDMode="Static" /></td>
                                <td colspan="4" style="border:solid;">
                                    <div style="overflow: scroll; height: 200px; width: 100%; text-align: left;">
                                        <asp:CheckBoxList ID="chkListPanel" runat="server" Font-Size="8pt" RepeatColumns="6" RepeatDirection="Horizontal" Font-Names="Verdana" ClientIDMode="Static">
                                        </asp:CheckBoxList>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </Ajax:UpdatePanel>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">
                        <asp:CheckBox ID="chkAllCentre" runat="server" ClientIDMode="Static" Text="Centre" onclick="checkAllCentre();" />
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-21">
                    <asp:CheckBoxList ID="chkCentre" runat="server" ClientIDMode="Static" CssClass="chkAllCentreCheck ItDoseCheckboxlist" onclick="chkCentreCon()" Height="16px" RepeatColumns="7" RepeatDirection="Horizontal" RepeatLayout="Table">
                    </asp:CheckBoxList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnReport" runat="server" Text="Report" CssClass="ItDoseButton"  OnClick="btnSearch_Click" TabIndex="5" ToolTip="Click to Open Report" />
        </div>
    </div>
</asp:Content>

