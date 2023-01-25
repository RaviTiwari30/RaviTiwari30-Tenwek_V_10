<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="ConsumeItem.aspx.cs" Inherits="Design_Store_ConsumeItem" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript">

        var keys = [];
        var values = [];

        $(document).ready(function () {
            debugger;
            var options = $('#<% = ListBox1.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });
            $('#<% = txtFirstNameSearch.ClientID %>').keyup(function (e) {
                searchByFirstChar(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), "", document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), "", values, keys, e)
                LoadDetail();
            });
            $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtFirstNameSearch.ClientID%>'), "", document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), "", values, keys, e)
                LoadDetail();
            });
            LoadDetail();
        });

        function validate() {
            if ($.trim($("#txtRemarks").val()) == "") {
                $("#lblMsg").text('Please Enter Remarks');
                $("#txtRemarks").focus();
                return false;
            }
            if (Page_IsValid) {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
            }
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));


                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function validatedot() {
            if (($("#<%=txtTransferQty.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtTransferQty.ClientID%>").val('');
                return false;
            }
            if ($(".GridViewStyle").find(".ItDoseTextinputNum").val() != null) {
                if (($(".GridViewStyle").find(".ItDoseTextinputNum").val().charAt(0) == ".")) {
                    $(".GridViewStyle").find(".ItDoseTextinputNum").val('');
                    return false;
                }
            }
            return true;
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Consume Medicial & General Item </b>
            <br />

            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Issue Items
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Store Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                            <asp:RadioButtonList runat="server" ID="rblStoreType" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblStoreType_SelectedIndexChanged" AutoPostBack="true">
                                <asp:ListItem Value="11" Selected="True">Medical Item</asp:ListItem>
                                <asp:ListItem Value="28">General Item</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                         
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search&nbsp;By&nbsp;First Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFirstNameSearch" ClientIDMode="Static" AutoCompleteType="disabled" TabIndex="1" runat="server" />
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                                Search By Any Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInBetweenSearch" runat="server" AutoCompleteType="Disabled" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4"></div>
                        <div class="col-md-10">
                            <asp:ListBox ID="ListBox1" runat="server" Height="200px" onchange="LoadDetail()"
                                TabIndex="2" Width="480px"></asp:ListBox>
                        </div>
                        <div class="col-md-4">

                        </div>
                        <div class="col-md-6">
                            <div id="stockOutput" style="max-height: 200px; overflow:auto;">
                            <table id="tbStock" rules="all" border="1" style="border-collapse: collapse; width: 100%; display: none" class="GridViewStyle">
                                <tr id="StockHeader">
                                    <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Batch No.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">Expiry</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="text-align: center">Avl.Qty.</th>
                                    <th class="GridViewHeaderStyle" scope="col" style=" text-align: center">Unit</th>
                                </tr>
                            </table>
                        </div>
                        </div>
                    </div>

                     <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Quantity
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-6">
                             <asp:TextBox ID="txtTransferQty" runat="server" CssClass="ItDoseTextinputText requiredField" AutoCompleteType="Disabled"
                                onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                                MaxLength="8" TabIndex="3"  > 
                            </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                         
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>


            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td style="text-align: right"></td>
                    <td>&nbsp; <asp:Button ID="btnAdd" runat="server" Text="Get Stock" OnClick="btnAdd_Click" CssClass="ItDoseButton" Visible="false" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:GridView ID="grdItem" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="Item" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" runat="Server" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="300px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Batch No." HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblBatchNumber" runat="server" Text='<%# Eval("BatchNumber") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Expiry" HeaderStyle-Width="100px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%#Eval("MedExpiryDate")%>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Cost Price" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUnitPrice" runat="server" Text='<%# Eval("UnitPrice") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Selling Price" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblMRP" runat="server" Text='<%# Eval("MRP") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Available Qty." HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblAvailQty" runat="server" Text='<%# Eval("AvlQty") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Unit" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUnitType" runat="server" Text='<%# Eval("UnitType") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Consume Qty." HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtIssueQty" runat="server" CssClass="ItDoseTextinputNum" Width="50px"
                                            onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                                            MaxLength="8"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom, Numbers"
                                            ValidChars="." FilterMode="validChars" TargetControlID="txtIssueQty">
                                        </cc1:FilteredTextBoxExtender>
                                        <asp:Label ID="lblItemID" runat="server" Text='<%# Eval("ItemID") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lblStockID" runat="server" Text='<%# Eval("stockid") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lblSubCategory" runat="server" Text='<%# Eval("SubCategoryID") %>'
                                            Visible="False"></asp:Label>
                                        <asp:Label ID="lblExpiry" runat="server" Text='<%# Eval("MedExpiryDate") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lblIsExpirable" runat="server" Text='<%# Eval("IsExpirable") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="lblPurTaxPer" runat="server" Text='<%# Eval("PurTaxPer") %>' Visible="False"></asp:Label>
                                         <asp:Label ID="lblSaleTaxPer" runat="server" Text='<%# Eval("SaleTaxPer") %>' Visible="False"></asp:Label>
                                        
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center"></td>
                </tr>
            </table>
            <div style="text-align: center">
                <asp:Button ID="btnAddItem" runat="server" Text="Add Item" CssClass="ItDoseButton"
                    OnClick="btnAddItem_Click" ValidationGroup="r" />
            </div>
            <div style="text-align: center">
                <cc1:FilteredTextBoxExtender ID="TQty" runat="server" FilterType="Custom, Numbers"
                    ValidChars="." FilterMode="validChars" TargetControlID="txtTransferQty">
                </cc1:FilteredTextBoxExtender>
                <asp:ValidationSummary ID="Validation" ShowSummary="false" ShowMessageBox="true"
                    runat="server" ValidationGroup="Qty" />
                <asp:RequiredFieldValidator ID="Qty" runat="server" ControlToValidate="txtTransferQty"
                    Text="*" ValidationGroup="Qty" ErrorMessage="Specify Qty" SetFocusOnError="true"
                    Display="None">
                </asp:RequiredFieldValidator>
            </div>
        </div>
        <asp:Panel ID="pnlStock" Visible="false" runat="server">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Item Details
                </div>
                <div>
                    <label class="labelForSearch" style="display: none;">
                        Amount :</label>
                    <asp:Label ID="lblAmount" runat="server" CssClass="ItDoseLabelSp" Style="display: none;">
                    </asp:Label>
                    <asp:GridView ID="gvIssueItem" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowCommand="gvIssueItem_RowCommand" Width="100%">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" Width="30px" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="30px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("ItemName")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Batch No." HeaderStyle-Width="80px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("BatchNumber")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Expiry" HeaderStyle-Width="86px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("Expiry")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="86px" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Quantity" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("IssueQty")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Unit" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("UnitType")%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" HorizontalAlign="Center" />
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false" HeaderText="Rate" HeaderStyle-Width="65px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Math.Round(Util.GetDouble(Eval("UnitPrice")), 2)%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="65px" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false" HeaderText="Amt" HeaderStyle-Width="75px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%# Math.Round(Util.GetDouble(Eval("Amount")), 2)%>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Narration/Comment" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" Visible="false">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtNarration" runat="server" MaxLength="100"></asp:TextBox>
                                    <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Remove" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                        CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" Width="30px" HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="text-align: right; width: 160px">Remarks :&nbsp;
                        </td>
                        <td>
                            <asp:TextBox ID="txtRemarks" runat="server" MaxLength="200" Width="280px" CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
                           
                        </td>
                    </tr>

                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">

                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                    OnClick="btnSave_Click" ValidationGroup="a" OnClientClick="return validate();" />


            </div>
        </asp:Panel>
    </div>

    <script type="text/javascript">

        function LoadDetail() {
            var DeptLedNo = '<%=ViewState["DeptLedNo"].ToString()%>';
            if ($("#<% = ListBox1.ClientID %>").val() != null) {
                var ItemID = $("#<% = ListBox1.ClientID %>").val().split('#')[0];
                $("#tbStock tr:not(#StockHeader)").remove();
                if (ItemID != "") {
                    $.ajax({
                        url: "ConsumeItem.aspx/showStock",
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
                                    $('#tbStock').append('<tr><td class="GridViewLabItemStyle"><span id="BatchNumber">' + data[i].BatchNumber + '</span></td><td class="GridViewLabItemStyle"><span id="MedExpiryDate">' + data[i].MedExpiryDate + '</span></td><td class="GridViewLabItemStyle" style="text-align:right"><span id="AvlQty" >' + data[i].AvlQty + '</span> </td><td class="GridViewLabItemStyle"><span id="UnitType">' + data[i].UnitType + '</span>  </td></tr>');
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
    </script>
</asp:Content>
