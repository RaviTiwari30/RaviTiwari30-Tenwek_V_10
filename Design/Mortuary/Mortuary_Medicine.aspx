<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mortuary_Medicine.aspx.cs" Inherits="Design_Mortuary_Mortuary_Medicine" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
      <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript">
        function validate() {
            if (Page_IsValid) {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('btnSave', '');
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
            }
        }
        function MoveUpAndDownText(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }

                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }
                }

            }
        }

        function MoveUpAndDownValue(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }

                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }
                }

            }
        }

        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }

                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }

        }
        function suggestValue(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
                var f = document.theSource;
                var listbox = listbox2;
                var textbox = textbox2;

                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                for (var m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].value.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;

                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(level) }
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
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div id="Pbody_box_inventory">
                    <div class="POuter_Box_Inventory" style="text-align: center;">
                        <b>Corpse Medicine</b>
                        <br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
                    </div>
                    <div class="POuter_Box_Inventory">
                        <div class="Purchaseheader">
                            Issue Items
                        </div>
                        <br />
                        <table style="width: 950px">
                            <tr>
                                <td style="width: 130px; text-align: right;">Items :
                                </td>
                                <td style="text-align: left;"></label><asp:TextBox onkeydown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                                    ID="txtSearch" AutoCompleteType="Disabled" onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00_ContentPlaceHolder1_ListBox1);"
                                    runat="server" Width="400px" CssClass="ItDoseTextinputText" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 130px; text-align: right;">&nbsp;
                                </td>
                                <td style="text-align: left;">
                                    <asp:ListBox ID="ListBox1" runat="server" CssClass="ItDoseDropdownbox" Height="150px"
                                        TabIndex="4" Width="405px"></asp:ListBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 130px; text-align: right;">Quantity :
                                </td>
                                <td style="text-align: left;">
                                    <asp:TextBox ID="txtTransferQty" runat="server" CssClass="ItDoseTextinputText" Width="50px"
                                        onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();"
                                        MaxLength="8">
                                    </asp:TextBox>&nbsp;                               
                                <asp:Button ID="btnAdd" runat="server" Text="Get Stock" OnClick="btnAdd_Click" CssClass="ItDoseButton" Width="95px" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
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
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <asp:Button ID="btnAddItem" runat="server" Text="Add Item" CssClass="ItDoseButton" OnClick="btnAddItem_Click" ValidationGroup="r" />
                                </td>
                            </tr>
                        </table>
                        <div style="">
                            <cc1:FilteredTextBoxExtender ID="TQty" runat="server" FilterType="Custom, Numbers" ValidChars="." FilterMode="validChars" TargetControlID="txtTransferQty">
                            </cc1:FilteredTextBoxExtender>
                            <asp:ValidationSummary ID="Validation" ShowSummary="false" ShowMessageBox="true" runat="server" ValidationGroup="Qty" />
                            <asp:RequiredFieldValidator ID="Qty" runat="server" ControlToValidate="txtTransferQty" Text="*" ValidationGroup="Qty" ErrorMessage="Specify Qty" SetFocusOnError="true" Display="None">
                            </asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="POuter_Box_Inventory">
                        <div class="Purchaseheader">
                            Item Details
                        </div>
                        <div>
                            <label class="labelForSearch" style="display: none;">
                                Amount :</label><br />
                            <asp:Label ID="lblAmount" runat="server" CssClass="ItDoseLabelSp" Style="display: none;">
                            </asp:Label><br />
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
                                        HeaderStyle-CssClass="GridViewHeaderStyle">
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
                        <div>
                            <table style="width: 100%">
                                <tr>
                                    <td style="text-align: center">
                                        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                                            OnClick="btnSave_Click" ValidationGroup="a" OnClientClick="return validate();" />
                                        &nbsp;&nbsp;
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnAdd" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnAddItem" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </form>
</body>
</html>
