<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="IndentSearch.aspx.cs" Inherits="Design_Store_IndentSearch"
    EnableEventValidation="true" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            $('#DateFrom').change(function () {
                ChkDate();

            });

            $('#DateTo').change(function () {
                ChkDate();
            });

        });
        function ChkDate() {

            $.ajax({

                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#DateFrom').val() + '",DateTo:"' + $('#DateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                        $('#btnSearchIndent,#<%=btnSN.ClientID %>,#<%=btnRN.ClientID %>,#<%=btnNA.ClientID %>,#<%=btnA.ClientID %>').attr('disabled', 'disabled');
                        $("#tbAppointment table").remove();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearchIndent,#<%=btnSN.ClientID %>,#<%=btnRN.ClientID %>,#<%=btnNA.ClientID %>,#<%=btnA.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }



    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="" style="text-align: center;">
                <b>Search Requisition</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Requisition Criteria
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
                            <asp:TextBox ID="DateFrom" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="fromdate" TargetControlID="DateFrom" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="DateTo" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="todate" TargetControlID="DateTo" Format="dd-MMM-yyyy"
                                runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server" ToolTip="Select Department To">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Requisition No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIndentNoToSearch" runat="server" ToolTip="Enter Requisition No."></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="border-collapse: collapse; width: 100%">
                <tr>
                    <td style="text-align: center" colspan='4'>
                        <asp:Button ID="btnSearchIndent" CssClass="ItDoseButton" runat="server" Text="Search" OnClick="btnSearchIndent_Click1" ClientIDMode="Static" />
                    </td>
                </tr>
            </table>
            <div style="padding-left: 50px">
                <div id="colorindication" runat="server">
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                  <div  class="col-md-4"></div>
                                <div  class="col-md-4">
                                    <asp:Button ID="btnSN" runat="server" Width="25px" Height="25px" BackColor="LightBlue" CssClass="circle"
                                        OnClick="btnSN_Click" ToolTip="Click for Open Requisition" Style="cursor: pointer;" />
                                    <b style="margin-top: 5px; margin-left: 5px;">Pending</b>
                                </div>
                                <div style="text-align: center" class="col-md-4">
                                    <asp:Button ID="btnRN" runat="server" Width="25px" Height="25px" BackColor="green"
                                        BorderStyle="Solid" CssClass="circle" OnClick="btnRN_Click" ToolTip="Click for Close Requisition" Style="cursor: pointer;" />
                                    <b style="margin-top: 5px; margin-left: 5px;">Issued</b>
                                </div>
                                <div style="text-align: center" class="col-md-4">
                                    <asp:Button ID="btnNA" runat="server" Width="25px" Height="25px" BackColor="LightPink"
                                        BorderStyle="Solid"  CssClass="circle" OnClick="btnNA_Click" ToolTip="Click for Reject Requisition" Style="cursor: pointer;" />
                                    <b style="margin-top: 5px; margin-left: 5px;">Reject</b>
                                </div>
                                <div style="text-align: center" class="col-md-4">
                                    <asp:Button ID="btnA" runat="server" Width="25px" Height="25px" BackColor="Yellow"
                                        BorderStyle="Solid"  CssClass="circle" OnClick="btnA_Click" ToolTip="Click for Partial Requisition" Style="cursor: pointer;" />
                                    <b style="margin-top: 5px; margin-left: 5px;">Partial</b>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Results
            </div>
            <div style="text-align: center">
                <asp:GridView ID="grdIndentSearch" runat="server" CssClass="GridViewStyle" OnRowCommand="gvGRN_RowCommand"
                    PageSize="8" AutoGenerateColumns="False" OnRowDataBound="grdIndentSearch_RowDataBound" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>

                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Requisition Date">
                            <ItemTemplate>
                                <asp:Label ID="lblIndentDate" runat="server" Text='<%# Eval("dtEntry")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="190px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Requisition No.">
                            <ItemTemplate>
                                <asp:Label ID="lblIndentNo" runat="server" Text='<%# Eval("IndentNo")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="190px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Department To">
                            <ItemTemplate>
                                <asp:Label ID="lblDepartment" runat="server" Text='<%# Eval("deptto") %>'></asp:Label>

                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="190px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Department From">
                            <ItemTemplate>
                                <asp:Label ID="lblToDepartment" runat="server" Text='<%# Eval("DeptFrom") %>'></asp:Label>
                                <%--<asp:Label ID="lblDeptTo" runat="server" Text='<%# Eval("DeptTo")%>'></asp:Label>--%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="190px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="StatusNew" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblStatusNew" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="View">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView" runat="server" CausesValidation="false" CommandName="AView"
                                    ImageUrl="~/Images/view.GIF" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>' />
                                <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbView1" runat="server" CausesValidation="false" CommandName="APrint"
                                    ImageUrl="~/Images/print.gif" CommandArgument='<%# Eval("IndentNo")+"#"+Eval("StatusNew")  %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                &nbsp;&nbsp;
            </div>
        </div>
    </div>
    <asp:Panel ID="Panel2" runat="server" CssClass="pnlItemsFilter" Style="display: none; width: 850px; height: 350px;"
        ScrollBars="Auto">
        <div>
            <table>
                <tr>
                    <td style="text-align: center;">
                        <label>
                            <strong>Requisition Detail:</strong></label>
                    </td>
                </tr>
                <tr>
                    <td valign="top" style="text-align: center;">
                        <asp:GridView ID="grdIndentdtl" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            Width="698px" OnRowDataBound="grdIndentdtl_RowDataBound">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="Requisition No." DataField="IndentNo" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Department From" DataField="DeptFrom" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Department To" DataField="DeptTo" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Item Name" DataField="ItemName" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Unit Type" DataField="UnitType" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Requested Qty." DataField="ReqQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Received Qty." DataField="ReceiveQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Pending Qty." DataField="PendingQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Rejected Qty." DataField="RejectQty" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Narration" DataField="Narration" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Date" DataField="DATE" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Raised By" DataField="EmpName" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField HeaderText="Rejected By" DataField="RejectBy" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:TemplateField HeaderText="StatusNew" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatusNew1" runat="server" Text='<%# Eval("StatusNew") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="left" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center;">
                        <asp:Button ID="btnCancel1" runat="server" Text="Cancel" CssClass="ItDoseButton" />
                    </td>
                </tr>
            </table>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" BackgroundCssClass="filterPupupBackground"
        PopupDragHandleControlID="dragHandle" CancelControlID="btnCancel1" PopupControlID="Panel2"
        TargetControlID="btn1" X="230" Y="130">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton" />
    </div>
</asp:Content>
