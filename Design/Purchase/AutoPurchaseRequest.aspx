<%@ Page Language="C#" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" MasterPageFile="~/DefaultHome.master" CodeFile="AutoPurchaseRequest.aspx.cs" Inherits="Design_Store_AutoPurchaseRequest" %>

<%--<%@ Register Src="EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>--%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager2" runat="server"></cc1:ToolkitScriptManager>
    <script type="text/javascript" language="javascript">
        function chkSelectAllIPD(fld) {
            var gridTable = document.getElementById('<%=grdViewPendingIndent.ClientID %>');
            var chkList = gridTable.document.getElementsByTagName("input");

            for (var i = 0; i < chkList.length; i++) {
                if (chkList[i].type == "checkbox") {
                    chkList[i].checked = fld.checked;
                }
            }
        }
        function SelectAllIcu() {
            debugger;
            if ($('[id$=chkIcuAll]').is(':checked')) {
                $('[id$=grdViewPendingIndent] tr').each(function () {
                    $(this).find('[id$=chkSelect]').prop('checked', true)
                });
            }
            else {
                $('[id$=grdViewPendingIndent] tr').each(function () {
                    if ($(this).find('[id$=chkSelect]').prop('checked', false)) {
                    }
                });
            }
        }
    </script>


    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Department Return Search</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-23">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                DATE FROM 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">

                            <asp:TextBox ID="ucDateFrom" Style="width: 75%" runat="server" TabIndex="1" ToolTip="Select From Date" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucDateFrom"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                DATE TO
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucDateTo" Style="width: 75%" runat="server" TabIndex="1" ToolTip="Select From Date" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd-MMM-yyyy" TargetControlID="ucDateTo"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoGroupList" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdoGroupList_SelectedIndexChanged" CellPadding="0" CellSpacing="0">
                                <asp:ListItem Selected="True" Value="1" Text="General Item"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Medical Item"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>

                </div>

            </div>
            <div class="POuter_Box_Inventory" style="width: 1289px">
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-23">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sub-Groups
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <div style="overflow: scroll; height: 120px; border: 1px solid; text-align: left;" class="border">
                                <asp:CheckBoxList ID="chkSubCat" runat="server" Font-Size="8pt" RepeatColumns="4" RepeatDirection="Horizontal" Font-Names="Verdana">
                                </asp:CheckBoxList>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-23">
                    <asp:RadioButtonList ID="rdoTypeBasis" runat="server" AutoPostBack="true" RepeatDirection="horizontal" OnSelectedIndexChanged="rdoTypeBasis_SelectedIndexChanged">
                        <asp:ListItem Value="IndentBasis" Text="On The Basis of Indent"></asp:ListItem>
                        <asp:ListItem Value="MinStockBasis" Text="On The Basis of Min Stock Level"></asp:ListItem>
                        <asp:ListItem Value="RolBasis" Text="On The Basis of ROL"></asp:ListItem>
                        <asp:ListItem Value="ConsumptionRolBasis" Text="On The Basis of Consumption ROL"></asp:ListItem>
                    </asp:RadioButtonList>
                </div>


            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-12">
                    <asp:CheckBoxList ID="chkIndentStatus" runat="server" Visible="false" RepeatDirection="Horizontal" Width="450px">
                        <asp:ListItem Text="Open" Value="Open"></asp:ListItem>
                        <asp:ListItem Text="Reject" Value="Reject"></asp:ListItem>
                        <asp:ListItem Text="Partial" Value="Partial"></asp:ListItem>
                    </asp:CheckBoxList>

                </div>
                <div class="col-md-11">
                    <asp:Button ID="btnSearch" runat="server" TabIndex="11"
                        Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click" />

                    <asp:Button ID="btnExport" runat="server" TabIndex="11"
                        Text="Export To Excel" CssClass="ItDoseButton" OnClick="btnExport_Click" />
                </div>


            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-23">
                    <asp:GridView ID="grdViewPendingIndent" runat="server" AutoGenerateColumns="false"
                        CssClass="GridViewStyle" OnRowCommand="grdViewPendingIndent_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkIcuAll" runat="server" onclick="SelectAllIcu(this);"
                                        CssClass="ItDoseCheckbox" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSelect" runat="server"  Checked="false" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="S.No">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Name" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("Name")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Last PRQty" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("PRQty")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="MS Stk" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("MS_Stk")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Hosp Stk" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("Hosp_Stk")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Min Limit" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("MinLimit")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="RO Level" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("ReorderLevel")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="RO Qty" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Eval("ReorderQty")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Indent Qty" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblIndentQty" runat="server" Text='<%# Eval("BalQty") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Req Qty" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtReqQty" runat="server" Width="25px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Purpose" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtPurpose" runat="server" Width="100px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Specification" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtSpecification" runat="server" Width="100px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblItemId" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblSubCatId" runat="server" Text='<%# Eval("SubCategoryID") %>' Visible="False"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("Unit") %>' Visible="False"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandName="Reject"
                                        ImageUrl="~/Images/Delete.gif" CommandArgument='<%#Container.DataItemIndex %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                </div>



            </div>

            <div class="row">
                <div class="col-md-1"></div>

                <div class="col-md-3">
                    <label class="pull-left">
                        Narration
                    </label>
                    <b class="pull-right">:</b>
                </div>

                <div class="col-md-11">
                    <asp:TextBox ID="txtNarration" runat="server" Width="300px" TextMode="MultiLine"
                        CssClass="ItDoseTextinputText" ValidationGroup="PR" />
                </div>
                <div class="col-md-9"></div>

            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSave" runat="server" TabIndex="11"
                Text="Save" CssClass="ItDoseButton" OnClick="btnSave_Click" />
        </div>




    </div>











</asp:Content>
