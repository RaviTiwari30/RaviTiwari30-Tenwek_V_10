<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SetItemQuotation.aspx.cs" Inherits="Design_Purchase_SetItemQuotation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
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
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
        function validatetax() {
            $("input[id*=txtPer]").bind("blur keyup keydown", function () {
                if (($(this).closest("tr").find("input[id*=txtPer]").val().charAt(0) == ".")) {
                    $(this).closest("tr").find("input[id*=txtPer]").val('');
                }
                var tax = $(this).closest("tr").find("input[id*=txtPer]").val();
                if (Number(tax) > 100) {
                    $(this).closest("tr").find("input[id*=txtPer]").val('');
                    alert('Invalid Discount');
                }
            });
            $("input[id*=txtTaxAmt]").bind("blur keyup keydown", function () {
                if (($(this).closest("tr").find("input[id*=txtTaxAmt]").val().charAt(0) == ".")) {
                    $(this).closest("tr").find("input[id*=txtTaxAmt]").val('');
                }
            });
            return true;
        }
        function chkRadio() {
            $(".GridViewStyle").find("input[id*=chkselect]").change(function () {
                if ($(".GridViewStyle").find("input[id*=chkselect] input:checked")) {
                    $(this).closest(".GridViewStyle").find("input[id*=chkselect]").not(this).prop('checked', false);
                }
            });
        }
        function wopen(url, name, w, h) {
            // Fudge factors for window decoration space.
            // In my tests these work well on all platforms & browsers.
            w += 32;
            h += 96;
            var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
            win.resizeTo(w, h);
            win.moveTo(10, 100);
            win.focus();
        }
    </script>
    <script type="text/javascript">
<!--
    function popup(url) {
        var width = 800;
        var height = 500;
        var left = (screen.width - width) / 2;
        var top = (screen.height - height) / 2;
        var params = 'width=' + width + ', height=' + height;
        params += ', top=' + top + ', left=' + left;
        params += ', directories=no';
        params += ', location=no';
        params += ', menubar=no';
        params += ', resizable=no';
        params += ', scrollbars=no';
        params += ', status=no';
        params += ', toolbar=no';
        newwin = window.open(url, 'windowname5', params);
        if (window.focus) { newwin.focus() }
        return false;
    }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Set Suppiler Quotation</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" Visible="false" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Searching Criteria&nbsp;
            </div>
            <div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Supplier
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlVendor" runat="server" TabIndex="1">
                                </asp:DropDownList>
                                <input type="button" id="btnaddNewVen" style="display: none" class="ItDoseButton" value="Add New" onclick="wopen('../Store/VendorDetail.aspx?Mode=1', 'popup1', 1040, 550); return false;" />
                                <asp:Button ID="Button1" Text="Add New" runat="server" CssClass="ItDoseButton" Style="display: none;" />
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Category
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlCategory" runat="server" Width="220px"
                                    TabIndex="3" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"
                                    AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Sub&nbsp;Category
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlSubCategory" runat="server" Width="220px"
                                    TabIndex="4" OnSelectedIndexChanged="ddlSubCategory_SelectedIndexChanged"
                                    AutoPostBack="true">
                                </asp:DropDownList>
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
                                <asp:DropDownList ID="ddlItemGroup" runat="server">
                                </asp:DropDownList>

                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 123px; text-align: right;">&nbsp;</td>
                        <td style="width: 35%; height: 20px; text-align: left"></td>
                        <td style="text-align: left; width: 10%;">
                            <input type="button" id="btnAddNewItem" class="ItDoseButton" style="display: none" value="Add New" onclick="wopen('../Store/ItemMaster.aspx?Mode=1', 'popup1', 1040, 550); return false;" />
                        </td>
                        <td style="text-align: left; width: 10%;">
                            <asp:Button ID="btnRefershItem" runat="server" Text="Refresh Items" Style="display: none"
                                CssClass="ItDoseButton" OnClick="btnRefershItem_Click" />
                        </td>
                    </tr>
                </table>

                <br />
                <div style="text-align: center;">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click" />
                    <br />
                </div>
                <table style="width: 100%; margin-top: 1%;">
                    <tr>
                        <td style="width: 200px;"></td>
                        <td style="width: 120px; height: 5px; height: 10px; border-right: black thin  solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen;">Item Detail</td>

                        <td style="width: 120px; border-right: black thin  solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink;">Supplier Detail</td>

                        <td style="width: 120px; border-right: black thin  solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: burlywood;">Default Quotation</td>
                        <td style="width: 200px;"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Quotation Details
            </div>
            <div style="text-align: center;">
                <asp:Repeater ID="rptitems" runat="server" OnItemCommand="rptitems_ItemCommand" OnItemDataBound="rptitems_ItemDataBound">
                    <HeaderTemplate>
                        <table style="border-collapse: collapse; width: 100%; font-size: 15px">
                            <tr style="text-align: left; color: #387C44; background-color: #fafad2;">
                                <th scope="col">&nbsp;</th>
                                <th scope="col">S.No.</th>
                                <th scope="col">ItemName</th>
                                <th scope="col">Manufacturer</th>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr style="text-align: center; background-color: lightgreen;">
                            <td class="GridViewItemStyle" style="width: 30px; text-align: left;">
                                <asp:ImageButton ID="imbVendor" runat="server" AlternateText="Hide" ImageUrl="~/Images/minus.png" CausesValidation="false" CommandArgument='<%# Eval("ItemID") %>' />
                            </td>
                            <td style="width: 30px;"><%# Container.ItemIndex+1 %></td>
                            <td style="width: 400px; text-align: left"><b><%# Eval("ItemName")%></b>
                                <asp:Label ID="lblItemID" Visible="false" runat="server" Text='<%# Eval("ItemID") %>'></asp:Label>
                            </td>

                            <td style="width: 300px; text-align: left"><%# Eval("ManuFacturer")%></td>

                        </tr>
                        <tr>
                            <td colspan="8" style="padding-left: 16px">
                                <asp:Repeater ID="rptvender" runat="server" OnItemCommand="rpt_setvender" OnItemDataBound="rptvender_ItemDataBound">
                                    <HeaderTemplate>
                                        <table style="border-collapse: collapse; font-size: 14px">
                                            <tr style="text-align: center; color: #ee00ee; background-color: #f0fff0; width: 100%;">
                                                <th scope="col">S.No.</th>
                                                <th scope="col" style="display: none;">StoreID</th>
                                                <th scope="col">Supplier</th>
                                                <th scope="col">Manufacturer</th>
                                                <th scope="col">Rate</th>
                                                <th scope="col">Discount</th>
                                                <th scope="col">Tax</th>
                                                <th scope="col">GST Type</th>
                                                <th scope="col">Deal</th>
                                                <th scope="col">CostPrice</th>
                                                <th scope="col">MRP</th>
                                                <th scope="col">FromDate</th>
                                                <th scope="col">ToDate</th>
                                                <th scope="col">EntryDate</th>
                                                <th scope="col">SetVendor</th>
                                            </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr style="text-align: center; width: 100%;" id="Tr1" runat="server">
                                            <td style="width: 5px; text-align: left;"><%# Container.ItemIndex+1 %></td>
                                            <td style="width: 80px; display: none;"><%# Eval("StoreRateID")%></td>
                                            <td style="width: 200px;"><%# Eval("VendorName")%></td>
                                            <td style="width: 100px;"><%# Eval("Name")%></td>
                                            <td style="width: 80px;"><%# Eval("Rate")%></td>
                                            <td style="width: 80px;"><%# Eval("DiscAmt")%></td>
                                            <td style="width: 80px;"><%# Eval("TaxAmt")%></td>
                                            <td style="width: 80px;"><%# Eval("GSTType")%></td>
                                            <td style="width: 80px;"><%# Eval("IsDeal")%></td>
                                            <td style="width: 80px;"><%# Eval("NetAmt")%></td>
                                            <td style="width: 80px;"><%# Eval("MRP")%></td>
                                            <td style="width: 80px;"><%# Eval("FromDate")%></td>
                                            <td style="width: 80px;"><%# Eval("ToDate")%></td>
                                            <td style="width: 80px;"><%# Eval("EntryDate")%></td>
                                            <td style="width: 80px;">
                                                <asp:Label ID="lblAppStatus" Visible="False" runat="server" Text='<%#Util.GetBoolean( Eval("AppStatus"))%>'></asp:Label>
                                                <asp:LinkButton ID="btnset" runat="server" CausesValidation="false" Text="Set" CommandName="set" CommandArgument='<%#Eval("VendorLedgerNo")+"#"+Eval("ItemID")+"#"+ Eval("StoreRateID") %>' Visible='<%#Util.GetBoolean( Eval("AppStatus"))%>'></asp:LinkButton>
                                                <asp:Label ID="lblVendorLedgerNo" runat="server" Visible="false" Text='<%# Eval("VendorLedgerNo")%>'></asp:Label>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </table>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</asp:Content>
