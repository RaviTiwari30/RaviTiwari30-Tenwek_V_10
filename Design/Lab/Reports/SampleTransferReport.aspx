<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SampleTransferReport.aspx.cs" Inherits="Design_Lab_SampleTransferReport" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Sample Transfer/Dispatch Report</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
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
                            <asp:CheckBoxList ID="chkCentre" onclick="chkCentreCon()"
                                RepeatColumns="7" ClientIDMode="Static" RepeatLayout="Table" CssClass="chkAllCentreCheck ItDoseCheckboxlist"
                                runat="server" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3"><label class="pull-left">Search By</label>  <b class="pull-right">:</b></div>
                        <div class="col-md-5" ><asp:RadioButtonList ID="rdbsearchby" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Value="F" Selected="True">From Center</asp:ListItem>
                            <asp:ListItem Value="T">To Center</asp:ListItem>
                                               </asp:RadioButtonList></div>
                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" TabIndex="7"
                            ToolTip="Select From Date"></asp:TextBox>
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
                          <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static"  TabIndex="7"
                            ToolTip="Select From Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="ToDate">
                        </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-8"></div>
                        <div class="col-md-8" style="text-align:center"> <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click"  Text="Search"/></div>
                        <div class="col-md-8"></div>
                    </div>
                </div></div></div>
       <script type="text/javascript">
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
</asp:Content>

