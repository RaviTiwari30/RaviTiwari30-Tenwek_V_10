<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="InterCentreStockReceive.aspx.cs" Inherits="Design_Store_InterCentreStockReceive" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#ucFromDate').change(function () {
                ChkDate();
            });

            $('#ucToDate').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#ucFromDate').val() + '",DateTo:"' + $('#ucToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        DisplayMsg('MM09', '<%=lblMsg.ClientID %>');
                        $('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                        $('#lblMsg').text('');
                        $('#btnSearch').removeAttr('disabled');
                        $('#<%=gvGRN.ClientID %>').val(null);

                    }
                }
            });
        }
    </script>

    <script type="text/javascript">
        $(document).ready(function () {

            var headerChk = $(".chkHeader input");
            var itemChk = $(".chkItem input");

            headerChk.click(function () {
                itemChk.each(function () {
                    this.checked = headerChk[0].checked;
                })
            });
            itemChk.each(function () {
                $(this).click(function () {
                    if (this.checked == false) { headerChk[0].checked = false; }
                })
            });
        });

    </script>

    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
        EnableScriptGlobalization="true" EnableScriptLocalization="true">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Centre Stock Receiving</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">
                        Sales No.
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtSalesNo" runat="server" ClientIDMode="Static"> </asp:TextBox>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">
                        From Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="ucFromDate" runat="server" ClientIDMode="Static"> </asp:TextBox>
                    <cc1:CalendarExtender ID="fromdate" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                        runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">
                        To Date
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="ucToDate" runat="server" ClientIDMode="Static"> </asp:TextBox>
                    <cc1:CalendarExtender ID="todate" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                        runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">
                        Status
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-7">
                    <asp:RadioButtonList ID="rbtStatus" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Value="4" Selected="True">Not-Received</asp:ListItem>
                        <asp:ListItem Value="1">Received</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search"
                    OnClick="btnSearch_Click" ClientIDMode="Static" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
            <div class="" style="text-align: center;">
                <asp:GridView ID="gvGRN" runat="server" AutoGenerateColumns="False"
                    CssClass="GridViewStyle" AllowPaging="true" PageSize="8" OnPageIndexChanging="gvGRN_PageIndexChanging" OnRowCommand="gvGRN_RowCommand" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="#">
                             <HeaderTemplate>
                                  <asp:CheckBox runat="server" ID="chkSelectAll" CssClass="chkHeader" ClientIDMode="Static" />
                             </HeaderTemplate>
                            <ItemTemplate>
                               <asp:CheckBox ID="chkSelect" runat="server" CssClass="chkItem" ClientIDMode="Static"></asp:CheckBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sales No.">
                            <ItemTemplate>
                                <asp:Label ID="lblSalesNo" runat="server" Text='<%# Eval("SalesNo").ToString()%>'></asp:Label></b>
                                 <asp:Label ID="lblStockID" runat="server" Visible="false" Text='<%# Eval("StockID").ToString()%>'></asp:Label></b>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="From Centre">
                            <ItemTemplate>
                                <%# Eval("FromCentre") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="From Dept.">
                            <ItemTemplate>
                                <%# Eval("FromDept") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <%# Eval("ItemName")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Qty.">
                            <ItemTemplate>
                                <%# Eval("InitialCount")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="135px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <%# Eval("StockDate")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%# Eval("IsPost")%>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Receive" Visible="false">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbPost" runat="server" CausesValidation="false" CommandName="APost" ImageUrl="~/Images/Post.gif" CommandArgument='<%# Eval("StockID") %>' Visible='<%# Util.GetBoolean(Eval("Post")) %>' />
                            
                            
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

           <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" Visible="false" CssClass="ItDoseButton" Text="Receive" OnClick="btnSave_Click" ClientIDMode="Static" />
            </div>
        </div>
    </div>
</asp:Content>
