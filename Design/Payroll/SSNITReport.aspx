<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="SSNITReport.aspx.cs" Inherits="Design_Payroll_SSNITReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
    <script type="text/javascript">
        var cal1;
        function pageLoad() {
            cal1 = $find("calendar1");
            modifyCalDelegates(cal1);
        }
        function modifyCalDelegates(cal) {
            //we need to modify the original delegate of the month cell.
            cal._cell$delegates =
            {
                mouseover: Function.createDelegate(cal, cal._cell_onmouseover),
                mouseout: Function.createDelegate(cal, cal._cell_onmouseout),

                click: Function.createDelegate(cal, function (e) {

                    e.stopPropagation();
                    e.preventDefault();

                    if (!cal._enabled) return;

                    var target = e.target;
                    var visibleDate = cal._getEffectiveVisibleDate();
                    Sys.UI.DomElement.removeCssClass(target.parentNode, "ajax__calendar_hover");
                    switch (target.mode) {
                        case "prev":
                        case "next":
                            cal._switchMonth(target.date);
                            break;
                        case "title":
                            switch (cal._mode) {
                                case "days": cal._switchMode("months"); break;
                                case "months": cal._switchMode("years"); break;
                            }
                            break;
                        case "month":
                            //if the mode is month, then stop switching to day mode.
                            if (target.month == visibleDate.getMonth()) {
                                //this._switchMode("days");
                            }
                            else {
                                cal._visibleDate = target.date;
                                //this._switchMode("days");
                            }
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;

                        case "year":
                            if (target.date.getFullYear() == visibleDate.getFullYear()) {
                                cal._switchMode("months");
                            }
                            else {
                                cal._visibleDate = target.date;
                                cal._switchMode("months");
                            }
                            break;

                            //                case "day":
                            //                    this.set_selectedDate(target.date);
                            //                    this._switchMonth(target.date);
                            //                    this._blur.post(true);
                            //                    this.raiseDateSelectionChanged();
                            //                    break;
                        case "today":
                            cal.set_selectedDate(target.date);
                            cal._switchMonth(target.date);
                            cal._blur.post(true);
                            cal.raiseDateSelectionChanged();
                            break;
                    }

                }

                 )
            }

        }

        function onCalendarShown(sender, args) {
            //set the default mode to month
            sender._switchMode("months", true);
            changeCellHandlers(cal1);

        }

        function changeCellHandlers(cal) {
            if (cal._monthsBody) {
                //remove the old handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $common.removeHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
                //add the new handler of each month body.
                for (var i = 0; i < cal._monthsBody.rows.length; i++) {
                    var row = cal._monthsBody.rows[i];
                    for (var j = 0; j < row.cells.length; j++) {
                        $addHandlers(row.cells[j].firstChild, cal._cell$delegates);
                    }
                }
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>SSNIT Reports </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
            </div>
            <div style="text-align: left;">
                <table style="width: 100%">
                    <tr>
                        <td align="center" colspan="3">

                            <asp:RadioButtonList ID="radSelect" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Employee Wise" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Employer Wise" Value="2"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Salary&nbsp;Month :&nbsp;
                        </td>
                        <td>
                            <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"
                                Width="100px" TabIndex="1" ToolTip="Click to Select Salary Month"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFromDate" runat="server" Format="MMM-yyyy" TargetControlID="txtFromDate" OnClientShown="onCalendarShown" BehaviorID="calendar1">
                            </cc1:CalendarExtender>
                        </td>
                        <td></td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td colspan="2">&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>&nbsp;
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" TabIndex="1" ToolTip="Click to Search" CssClass="ItDoseButton" />&nbsp;&nbsp;
                   <asp:Button ID="btnExport" runat="server" Text="Export To Excel"
                       TabIndex="2" ToolTip="Click to Export" CssClass="ItDoseButton"
                       OnClick="btnExport_Click" />
        </div>
    </div>
</asp:Content>