<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="NABHReport.aspx.cs" Inherits="Design_EDP_NABHReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
        <script type="text/javascript">
            var cal1; var cal2;
            function pageLoad() {
                cal1 = $find("calFromDate");
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

            function onCalendarShown1(sender, args) {
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
          <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
        EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>NABH Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria
            </div>

            </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
         <table style=" width:100%;border-collapse:collapse">
                <tr>
                    <td style="text-align: right; width: 20%">Month Of :&nbsp;
                    </td>
                    <td style="text-align: left; width: 30%">
                        <asp:TextBox ID="txtFromDate" runat="server"
                            ToolTip="Click To Select From Date" Width="110px" TabIndex="1"
                            ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server"
                            TargetControlID="txtFromDate" Format="MMM-yyyy" BehaviorID="calFromDate" OnClientShown="onCalendarShown1">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 20%; text-align: right">
                    </td>
                    <td style="text-align: left;width: 30%">
                     
                    </td>
                </tr>
               </table>
            </div>
               <div class="POuter_Box_Inventory" style="text-align: center;">
                    
                        <asp:Button ID="btnSearch" runat="server" Text="Search"
                            OnClick="btnSearch_Click" ClientIDMode="Static" TabIndex="3"
                            ToolTip="Click To search" CssClass="ItDoseButton" />
                  
                </div>
               </div>
</asp:Content>

