<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DirectIssueLaundaryItem.aspx.cs" Inherits="Design_Laundry_DirectIssueLaundaryItem" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript" >
        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = ListBox1.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            $('#<%=txtSearch.ClientID %>').keyup(function (e) {
                searchByInBetween("", "", document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), "", values, keys, e)
                LoadDetail();
            });
            
        });
        function validate() {
            if ($("#<%=txtTransferQty.ClientID %>").val() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Enter Transfer Quantity');
                return false;
            }
            if ($("#<%=ddlDept.ClientID %>").val() == "Select")
            {
                $("#<%=lblMsg.ClientID %>").text('Please Select Department');
                $("#<%=ddlDept.ClientID %>").focus();
                return false;
            }
            else {
                $("#<%=lblMsg.ClientID %>").text('');
                if (Page_IsValid) {
                    document.getElementById('<%=btnSearch.ClientID%>').disabled = true;
                    document.getElementById('<%=btnSearch.ClientID%>').value = 'Submitting...';
                    __doPostBack('ctl00$ContentPlaceHolder1$btnSearch', '');
                }
                else {
                    document.getElementById('<%=btnSearch.ClientID%>').disabled = false;
                    document.getElementById('<%=btnSearch.ClientID%>').value = 'ADD';
                }
            }
        }
        $(document).ready(function () {
         
            $("#<%=btnAddItem.ClientID %>").click(function () {
                if (Page_IsValid) {
                    document.getElementById('<%=btnAddItem.ClientID%>').disabled = true;
                    document.getElementById('<%=btnAddItem.ClientID%>').value = 'Submitting...';
                    __doPostBack('ctl00$ContentPlaceHolder1$btnAddItem', '');
                }
                else {
                    document.getElementById('<%=btnAddItem.ClientID%>').disabled = false;
                    document.getElementById('<%=btnAddItem.ClientID%>').value = 'Add Item';
                }
            });
            $("#<%=btnSave.ClientID %>").click(function () {
                if (Page_IsValid) {
                    document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                    document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                    __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
                }
                else {
                    document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                    document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
                }
            });
        });
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <b>Laundry Direct Issue To Department </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Issue Items</div>
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblDept" runat="server" Text="Department :&nbsp;"></asp:Label>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" runat="server" CssClass="requiredField" Width="" ClientIDMode="Static">
                            </asp:DropDownList>
                            <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Items
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox
                                ID="txtSearch" AutoCompleteType="Disabled"
                                runat="server" Width="" />
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-21">
                            <asp:ListBox ID="ListBox1" TabIndex="4" runat="server"
                                Width="405px" Height="97px"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Transfer Qty.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTransferQty" runat="server" CssClass="ItDoseTextinputNum requiredField"
                                Width=""></asp:TextBox>
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                            <cc1:FilteredTextBoxExtender ID="TQty" runat="server" FilterMode="validChars"
                                FilterType="Numbers" TargetControlID="txtTransferQty">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" OnClick="btnSearch_Click" OnClientClick="return validate();" Text="Add" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <asp:Panel ID="pnlHide"  runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Item Details
                </div>
                <div class="" style="text-align: center">
                  <asp:GridView ID="grdItem" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    TabIndex="8" OnRowDataBound="grdItem_RowDataBound" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="Server" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  Width="30px"/>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="420px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Batch No.">
                            <ItemTemplate>
                                <asp:Label ID="lblBatchNumber" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry">
                            <ItemTemplate>
                                <%#Eval("MedExpiryDate")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="CostPrice" Visible="false">
                            <ItemTemplate>
                                <%#Eval("UnitPrice")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="MRP" Visible="false">
                            <ItemTemplate>
                                <%#Eval("MRP")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Avail. Qty.">
                            <ItemTemplate>
                                <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvailQty") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Issue Qty.">
                            <ItemTemplate>
                                <asp:TextBox ID="txtIssueQty" runat="server" CssClass="ItDoseTextinputNum" Width="50px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                                    TargetControlID="txtIssueQty" ValidChars=".">
                                </cc1:FilteredTextBoxExtender>
                                <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("StockID") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                    Visible="False"></asp:Label>
                                <asp:Label ID="lblUnitPrice" runat="server" Text='<%# Eval("UnitPrice") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblTax" runat="server" Text='<%# Eval("Tax") %>' Visible="False"></asp:Label>
                                <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("UnitType") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMajorUnit" runat="server" Text='<%# Eval("MajorUnit") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMinorUnit" runat="server" Text='<%# Eval("MinorUnit") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblConversionFactor" runat="server" Text='<%# Eval("ConversionFactor") %>' Visible="false"></asp:Label>
                                <asp:Label ID="lblMedExpiryDate" runat="server" Text='<%# Eval("MedExpiryDate") %>'
                                    Visible="false"></asp:Label>
                               
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                    <br />
                    &nbsp;<asp:Button ID="btnAddItem" runat="server" CssClass="ItDoseButton" OnClick="btnAddItem_Click"
                        TabIndex="10" Text="Add Item" />
                </div>
            </div>
        </asp:Panel>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Item Details
            </div>
            <div class="" style="text-align: center">
             <asp:GridView ID="grdItemDetails" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdItemDetails_RowCommand" TabIndex="11" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Item Name">
                            <ItemTemplate>
                                <%# Eval("ItemName") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="420px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Rate" Visible="false">
                            <ItemTemplate>
                                <%# Math.Round(Util.GetDouble(Eval("MRP")),2) %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Batch No.">
                            <ItemTemplate>
                                <%# Eval("BatchNumber") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Disc. (%)" Visible="false">
                            <ItemTemplate>
                                <%# Eval("Discount")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Disc." Visible="false">
                            <ItemTemplate>
                                <%# Math.Round(Util.GetDouble(Eval("DiscountAmt")),2) %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tax (%)" Visible="false">
                            <ItemTemplate>
                                <%#Eval("Tax")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Qty.">
                            <ItemTemplate>
                                <%# Eval("IssueQty")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText=" Amount" Visible="false">
                            <ItemTemplate>
                                <%# Math.Round(Util.GetDouble(Eval("GrossAmount")),2) %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Remove">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbRemove" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                    CommandName="imbRemove" ImageUrl="~/Images/Delete.gif" ToolTip="Remove Item" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="55px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                &nbsp;
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Requisition No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIndent" runat="server" Width=""></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <asp:CheckBox ID="chkPrint" runat="server" Text="Print" />
                            &nbsp;<asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                                OnClick="btnSave_Click" ValidationGroup="a" OnClientClick="return validateSave();" Enabled="false" />
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Issue No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIssueNo" runat="server" MaxLength="15" Width=""></asp:TextBox>
                        </div>
                        <div class="col-md-5">
                            <asp:Button ID="btnReprint" runat="server" Text="Reprint" CssClass="ItDoseButton" OnClick="btnReprint_Click" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

    </div>
<%--     <script type="text/javascript">

         function LoadDetail() {
             var DeptLedNo = $('#<%=ddlDept.ClientID%>').val();
                if ($("#<% = ListBox1.ClientID %>").val() != null) {
                    var ItemID = $("#<% = ListBox1.ClientID %>").val().split('#')[0];
                    $("#tbStock tr:not(#StockHeader)").remove();
                        if (ItemID != "") {
                            $.ajax({
                                url: "DirectIssueLaundaryItem.aspx/showReturnQty",
                                data: '{ItemID:"' + ItemID + '",DeptLedNo:"' + DeptLedNo + '"}',
                                type: "POST",
                                async: false,
                                dataType: "json",
                                contentType: "application/json; charset=utf-8",
                                success: function (mydata) {
                                    var data = jQuery.parseJSON(mydata.d);
                                    if (data != null) {
                                        $('#tbStock').css('display', 'block');
                                        for (var i = 0; i < data.length; i++) {
                                            $('#tbStock').append('<tr><td class="GridViewLabItemStyle"><span id="ReturnDate">' + data[i].ReturnDate + '</span></td><td class="GridViewLabItemStyle"><span id="Quantity" style="text-align:center">' + data[i].ReturnQty + '</span></td></tr>');
                                        }
                                    }
                                    else {
                                        $('#tbStock').css('display', 'none');

                                    }
                                }
                            });

                        }
                    }
                }
        </script>--%>
</asp:Content>
