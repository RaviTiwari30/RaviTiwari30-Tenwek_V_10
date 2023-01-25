<%@ Page Language="C#" AutoEventWireup="true"
    MasterPageFile="~/DefaultHome.master" CodeFile="RenewExpiryItem.aspx.cs" Inherits="Design_Store_RenewExpiryItem" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=ucFromDate.ClientID %>').change(function () {
                ChkDate();
            });

            $('#<%=ucToDate.ClientID %>').change(function () {
                ChkDate();
            });
            if ($("#<%=chkisexpirable.ClientID %>").attr('checked')) {
                $("#<%=ucFromDate.ClientID %>").attr('disabled', false);
            }
            else {
                $("#<%=ucFromDate.ClientID %>").attr('disabled', true);
            }
        });
        function ChkDate() {
            $.ajax({
                url: "../Common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#<%=ucFromDate.ClientID %>').val() + '",DateTo:"' + $('#<%=ucToDate.ClientID %>').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnReport.ClientID %>,#<%=btnSelect.ClientID %>').attr('disabled', 'disabled');
                        $("#<%=grdItems.ClientID %>").remove();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSelect.ClientID %>').removeAttr('disabled');
                        $('#<%=btnReport.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }

        function clicked() {

            if ($("#<%=chkisexpirable.ClientID %>").attr('checked')) {
                $("#<%=ucFromDate.ClientID %>").attr('disabled', false);
            }
            else {
                $("#<%=ucFromDate.ClientID %>").attr('disabled', true);
            }
        }
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Renew Expired Items</b>
            <br />
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
                                <asp:CheckBox ID="chkisexpirable" runat="server" Checked="true" onclick="clicked()"
                                    Text="Ignore Dates" />
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucFromDate" runat="server">
                            </asp:TextBox>
                            <cc1:CalendarExtender ID="clcFDate" runat="server" TargetControlID="ucFromDate" Format="dd-MMM-yyyy"
                                ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ucToDate" runat="server">
                        </asp:TextBox>
                        <cc1:CalendarExtender ID="clcToDate" runat="server" TargetControlID="ucToDate" Format="dd-MMM-yyyy"
                            ClearTime="true">
                        </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" AutoPostBack="true">
                            <asp:ListItem Value="STO00001">Medical Store</asp:ListItem>
                            <asp:ListItem Value="STO00002">General Store</asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtItemName" runat="server"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

            <table style="width: 100%; border-collapse: collapse">
               
                <tr>
                    <td></td>
                    <td>
                        <div style="display: none">
                            <label class="labelForTag">
                                Item Type :</label>
                            <asp:RadioButtonList ID="rbtnMedNonMed" runat="server" RepeatDirection="horizontal">

                                <asp:ListItem Selected="True" Text="Medical Items" Value="11">
                                </asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </td>
                    <td style="width: 28%;">
                        <div style="float: left;">
                            <div style="display: none">
                                <label class="labelForTag">
                                    Store :</label><asp:DropDownList ID="ddlStoreLoc" runat="server" CssClass="ItDoseDropdownbox" Width="150px">
                                    </asp:DropDownList>
                                &nbsp;
                            </div>

                            <div style="display: none">
                                <label class="labelForTag">
                                    Department</label>
                                <asp:DropDownList ID="ddldepartment" runat="server" CssClass="ItDoseDropdownbox"
                                    Width="150px">
                                </asp:DropDownList>
                            </div>
                        </div>
                    </td>
                    <td style="width: 9%;">
                        <div style="float: left; clear: both; margin-left: 100px;">
                            <div style="float: left; display: none">
                                <label class="labelForTag" style="text-align: center">
                                    Filter Type :</label><asp:RadioButtonList ID="rbtType" runat="server">

                                        <asp:ListItem Selected="True" Value="0">Hospital Store</asp:ListItem>

                                    </asp:RadioButtonList>
                            </div>

                        </div>
                    </td>
                </tr>
            </table>



        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSelect" runat="server" CssClass="ItDoseButton" Enabled="false" OnClick="btnSelect_Click"
                Text="Search" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Enabled="false" Text="Report" OnClick="btnReport_Click" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>

            <asp:GridView ID="grdItems" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                CssClass="GridViewStyle" OnPageIndexChanging="grdItems_PageIndexChanging" OnRowCancelingEdit="grdItems_RowCancelingEdit"
                OnRowEditing="grdItems_RowEditing" OnRowUpdating="grdItems_RowUpdating"
                PageSize="20" Width="970px">
                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                <Columns>
                    <asp:TemplateField HeaderText="Item Name" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <EditItemTemplate>
                            <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="400px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Expiry Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtExpDate" runat="server" Text='<%# Bind("MedExpiryDate") %>' Width="90px"></asp:TextBox>
                            <cc1:CalendarExtender ID="ccExp" runat="server" TargetControlID="txtExpDate" Format="dd-MMM-yyyy"
                                ClearTime="true">
                            </cc1:CalendarExtender>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblExpDate" runat="server" Text='<%# Bind("MedExpiryDate") %>'></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Batch No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <%# Eval("BatchNumber")%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="100px" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Quantity" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:Label ID="lblQuantity" runat="server" Text='<%# Eval("InHandQty") %>'></asp:Label>
                            <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Edit" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                        <ItemTemplate>
                            <asp:ImageButton ID="imbEdit" runat="server" ToolTip="Edit" CausesValidation="false" CommandName="Edit" ImageUrl="~/Images/edit.png" CommandArgument='<%# Container.DataItemIndex %>' />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:ImageButton ID="imbUpdate" runat="server" ToolTip="Update" CausesValidation="false" CommandName="Update" ImageUrl="~/Images/post.gif" CommandArgument='<%# Container.DataItemIndex %>' />
                            &nbsp;
                            <asp:ImageButton ID="imbCancel" runat="server" ToolTip="Cancel" CausesValidation="false" CommandName="Cancel" ImageUrl="~/Images/Delete.gif" CommandArgument='<%# Container.DataItemIndex %>' />
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

        </div>
    </div>
</asp:Content>
