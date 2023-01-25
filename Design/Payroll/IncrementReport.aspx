<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="IncrementReport.aspx.cs" Inherits="Design_Payroll_IncrementReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    
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
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Increment Report </b>
            <br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Increment Report
            </div>
            <div style="text-align: left;">
                <table width="100%">
                    <tr>
                        <td align="center" style="width: 14%; height: 18px"></td>
                        <td style="width: 19%; height: 18px" align="right">Report Format :&nbsp;
                        </td>
                        <td align="left" style="width: 20%; height: 18px">
                            <asp:RadioButtonList ID="RadioButtonList2" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True">PDF</asp:ListItem>
                                <asp:ListItem>Word</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td style="width: 20%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                    </tr>
                    <tr>
                        <td align="center" style="width: 14%; height: 18px"></td>
                        <td style="width: 19%; height: 18px" align="right">
                            <asp:Label ID="lblDate" runat="server" Text="Salary Month :&nbsp;"></asp:Label>
                        </td>
                        <td style="width: 20%; height: 18px" align="left">
                            <asp:TextBox ID="txtDate" runat="server" Visible="true" TabIndex="1" ToolTip="Click to Select Salary Month"></asp:TextBox>
                            <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="MMM-yyyy" OnClientShown="onCalendarShown" BehaviorID="calendar1">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 20%; height: 18px">&nbsp;
                        </td>
                        <td style="width: 20%; height: 18px"></td>
                        <td style="width: 20%; height: 18px"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" TabIndex="2" CssClass="ItDoseButton" ToolTip="Click to Search" />
        </div>
    </div>
</asp:Content>