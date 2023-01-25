<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="ItemMaster.aspx.cs" Inherits="Design_Store_ItemMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript">

        function UnitChange() {
            if ($('#<%=ddl_MajorUnit.ClientID %>').val() != "Select" && $('#<%=ddl_minor.ClientID %>').val() != "Select") {
                if ($('#<%=ddl_MajorUnit.ClientID %>').val() == $('#<%=ddl_minor.ClientID %>').val()) {
                    $("#txtCFactor").prop("readOnly", true);
                    $("#txtCFactor").val('1');
                }
                else {
                    $("#txtCFactor").prop("readonly", false);
                    $("#txtCFactor").val('');
                }
            }
        }
        function Validate() {
            if ($.trim($("#<%=txtName.ClientID%>").val()) == "") {
                $("#<%=txtName.ClientID%>").focus();
                $("#<%=lblMessage.ClientID%>").text('Please Enter Item Name');
                return false;
            }
            //if ($.trim($("#<%=txtDesc.ClientID%>").val()) == "") {
            // $("#<%=txtDesc.ClientID%>").focus();
            // $("#<%=lblMessage.ClientID%>").text('Please Enter Description');
            //  return false;
            //  }
            if ($.trim($("#<%=ddlGroup.ClientID%>").val()) == "0") {
                $("#<%=ddlGroup.ClientID%>").focus();
                $("#<%=lblMessage.ClientID%>").text('Please Select Group');
                return false;
            }
            if ($.trim($("#<%=ddlmanufacture.ClientID%>").val()) == "0") {
                $("#<%=ddlmanufacture.ClientID%>").focus();
                $("#<%=lblMessage.ClientID%>").text('Please Select Manufacturer');
                return false;
            }
            if ($.trim($("#<%=ddl_MajorUnit.ClientID%>").val()) == "0") {
                $("#<%=ddl_MajorUnit.ClientID%>").focus();
                $("#<%=lblMessage.ClientID%>").text('Please Select Purchase Unit');
                return false;
            }
            if ($.trim($("#<%=ddl_minor.ClientID%>").val()) == "0") {
                $("#<%=ddl_minor.ClientID%>").focus();
                $("#<%=lblMessage.ClientID%>").text('Please Select Sale Unit');
                return false;
            }

            if (Number($('#<%=txtMinLevel.ClientID %>').val()) > Number($('#<%=txtMaxLevel.ClientID %>').val())) {
                alert('Max Level Should Be Greater Than Min Level');
                return false;
            }

            if (Number($('#<%=txtReorderLevel.ClientID %>').val()) < Number($('#<%=txtMinLevel.ClientID %>').val())) {
                alert('Reorder Level Should Be between Min Level or Max Level');
                return false;
            }
            if (Number($('#<%=txtReorderLevel.ClientID %>').val()) > Number($('#<%=txtMaxLevel.ClientID %>').val())) {
                alert('Reorder Level Should Be between Min Level or Max Level');
                return false;
            }
            if (Number($('#<%=txtReorderQty.ClientID %>').val()) > Number($('#<%=txtMaxLevel.ClientID %>').val())) {
                alert('Reorder Qty Should Not Be Greater Than Max Level');
                return false;
            }

            if ($('#<%=rbtnGst.ClientID%> input[type="radio"]:checked').val() == "IGST") {
                if ($("#<%=txtIGst.ClientID%>").val() == "" || $("#<%=txtIGst.ClientID%>").val() < 0) {
                    alert('Enter IGST %');
                    return false;
                }
            }

            if ($('#<%=rbtnGst.ClientID%> input[type="radio"]:checked').val() == "CGST&SGST") {
                if ($("#<%=txtCGst.ClientID%>").val() == "" || $("#<%=txtCGst.ClientID%>").val() < 0) {
                    alert('Enter CGST %');
                    return false;
                }

                if ($("#<%=txtSGst.ClientID%>").val() == "" || $("#<%=txtSGst.ClientID%>").val() < 0) {
                    alert('Enter SGST %');
                    return false;
                }
            }
            
            if ($('#<%=rbtnGst.ClientID%> input[type="radio"]:checked').val() == "CGST&UTGST") {
                if ($("#<%=txtCGst.ClientID%>").val() == "" || $("#<%=txtCGst.ClientID%>").val() < 0) {
                    alert('Enter CGST %');
                    return false;
                }

                if ($("#<%=txtUTGST.ClientID%>").val() == "" || $("#<%=txtUTGST.ClientID%>").val() < 0) {
                    alert('Enter UTGST %');
                    return false;
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
            if (keychar == "#" || keychar == "'" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "48" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
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
            if (($("#<%=txtstrength.ClientID%>").val().charAt(0) == ".")) {
                $("#<%=txtstrength.ClientID%>").val('');
                return false;
            }
            return true;
        }

        function validatespace() {
            var Pname = $('#<%=txtName.ClientID %>').val();
            if (Pname.charAt(0) == ' ' || Pname.charAt(0) == '.' || Pname.charAt(0) == '0' || Pname.charAt(0) == '%' || Pname.charAt(0) == '&' || Pname.charAt(0) == '@' || Pname.charAt(0) == '$' || Pname.charAt(0) == '^' || Pname.charAt(0) == '*' || Pname.charAt(0) == '(' || Pname.charAt(0) == ')' || Pname.charAt(0) == '_' || Pname.charAt(0) == '-' || Pname.charAt(0) == '#') {
                $('#<%=txtName.ClientID %>').val('');
                Pname.replace(Pname.charAt(0), "");
                return false;
            }
            var ItemCatalog = $('#<%=txtItemCatalog.ClientID %>').val();
            if (ItemCatalog.charAt(0) == ' ' || ItemCatalog.charAt(0) == '.' || ItemCatalog.charAt(0) == ',' || ItemCatalog.charAt(0) == '0' || ItemCatalog.charAt(0) == '%' || ItemCatalog.charAt(0) == '&' || ItemCatalog.charAt(0) == '@' || ItemCatalog.charAt(0) == '$' || ItemCatalog.charAt(0) == '^' || ItemCatalog.charAt(0) == '*' || ItemCatalog.charAt(0) == '(' || ItemCatalog.charAt(0) == ')' || ItemCatalog.charAt(0) == '_' || ItemCatalog.charAt(0) == '-' || ItemCatalog.charAt(0) == '#') {
                $('#<%=txtItemCatalog.ClientID %>').val('');
                ItemCatalog.replace(ItemCatalog.charAt(0), "");
                return false;
            }
        }

        function HideDisplay(gst) {
            if (gst == "0") {
                $("#trPartialSgstTax").hide();
                $("#trPartialUTGSUTax").show();
            }
            else {
                $("#trPartialSgstTax").show();
                $("#trPartialUTGSUTax").hide();
            }
        }
    </script>
    <script type="text/javascript">


        function MoveUpAndDownText(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                ///__doPostBack('ListBox1','')
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

                    //listbox.options[0].selected=true;
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

    </script>
    <script type="text/javascript">
<!--
    function wopen(url, name, w, h) {
        w += 32;
        h += 96;
        var win = window.open(url, name, 'width=' + w + ', height=' + h + ', ' + 'location=no, menubar=no, ' + 'status=no, toolbar=no, scrollbars=no, resizable=no');
        win.resizeTo(w, h);
        win.moveTo(10, 100);
        win.focus();
    }
    // -->
    </script>

    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>New Items</b>
            <br />
            <asp:Label ID="lblMessage" runat="server" CssClass="ItDoseLblError"
                EnableViewState="false" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" runat="server" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Groups
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSubCategory"
                                runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlSubCategory_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search By Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearch" CssClass="requiredField" runat="server"> </asp:TextBox>
                            <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-21">
                            <asp:LinkButton ID="lnkView" OnClick="lnkView_Click" runat="server" CssClass="ItDoseLblSpBl" />&nbsp;
                            <asp:LinkButton ID="lnkReport" runat="server" CssClass="ItDoseLblSpBl" OnClick="lnkReport_Click"> </asp:LinkButton>
                            &nbsp;<asp:LinkButton ID="lnkwrd" runat="server" CssClass="ItDoseLblSpBl" OnClick="lnkwrd_Click"> </asp:LinkButton>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div style="width: 100%; max-height: 200px; overflow: auto;">
                <table style="border-collapse: collapse;">
                    <tr>
                        <td colspan="4">
                            <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                            <asp:GridView ID="grdServiceItems" runat="server" OnSelectedIndexChanged="grdServiceItems_SelectedIndexChanged"
                                CssClass="GridViewStyle" AutoGenerateColumns="False" Width="100%">
                                <Columns>
                                    <asp:CommandField ShowSelectButton="True" SelectImageUrl="~/Images/Post.gif" ButtonType="Image" HeaderText="Select">
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                    </asp:CommandField>
                                         <asp:BoundField DataField="ItemID" HeaderText="ItemID">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Item Name" ItemStyle-Width="250px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemName" Text='<%# DataBinder.Eval(Container.DataItem,"TypeName")%>' runat="server"></asp:Label>
                                            <asp:Label ID="lblSubCatID" Text='<%# DataBinder.Eval(Container.DataItem,"SubID")%>' Visible="false" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Item Type" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblItemType" Text='<%# DataBinder.Eval(Container.DataItem,"ItemType")%>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="HSNCode" HeaderText="HSN Code" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ItemCatalog" HeaderText="Item Catalog No."  Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ManuFacturer" HeaderText="Manufacturer">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Name" HeaderText="Creater Name">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="200px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="CreaterDateTime" HeaderText="Created Date">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="200px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Description" ItemStyle-Width="250px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDesc" Text='<%# DataBinder.Eval(Container.DataItem,"Description")%>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item Code">
                                        <ItemTemplate>
                                              <asp:Label ID="lblItemDose" runat="server" Style="display: none;"  Text='<%# DataBinder.Eval(Container.DataItem,"ItemDose")%>'></asp:Label>
                                        <asp:Label ID="lblItemID" runat="server" Style="display: none;" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'></asp:Label>
                                            <asp:Label ID="lblItemCode" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemCode")%>'></asp:Label>
                                            <asp:Label ID="lblRack" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Rack")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblShelf" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Shelf")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblMaxLevel" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MaxLevel")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblMinLevel" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MinLevel")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblReorderLevel" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ReorderLevel")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblReorderQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ReorderQty")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblMaxReorderQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MaxReorderQty")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblMinReorderQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MinReorderQty")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblPacking" runat="server"  Text='<%# DataBinder.Eval(Container.DataItem,"Packing")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblPurchaseQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"PurchaseQty")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblSaleQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SaleQty")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblSaleUnitType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SaleUnitType")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblcheckisexpirable" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsExpirable")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblMajorUnit" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MajorUnit")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblMinorUnit" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MinorUnit")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblCFactor" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ConversionFactor")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblScheduleType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ScheduleType")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblRoute" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Route")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblIsOnSellingPrice" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsOnSellingPrice ")%>' Visible="false"></asp:Label>
                                            <asp:Label ID="lblSellingMargin" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SellingMargin ")%>' Visible="false"></asp:Label>
                                            
                                            <%-- <asp:Label ID="lblType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ValType")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblLine" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ValLine")%>' Visible="false"></asp:Label>--%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Is Active">
                                    <ItemTemplate>
                                        <asp:Label ID="lblActive" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsActive")%>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="MajorUnit" HeaderText="Purchase Unit">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>

                                <asp:BoundField DataField="MinorUnit" HeaderText="Sale Unit">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <%-- <asp:BoundField DataField="ValType" HeaderText="Val Type">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>

                                 <asp:BoundField DataField="ValLine" HeaderText="Val Line">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>--%>

                                    <asp:BoundField DataField="ConversionFactor" HeaderText="Issue Factor">
                                        <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="IsUsable" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblIsUsable" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsUsable") %>'></asp:Label>
                                            <asp:Label ID="lblsubcategoryID" Visible="false" Text='<%# DataBinder.Eval(Container.DataItem,"SubCategoryID") %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="MajorUnit" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblUnitType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"UnitType") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="IsBilled" Visible="false">
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblistobill" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"tobebilled") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="TypeID" Visible="False">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblTypeID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Type_id") %>'></asp:Label>
                                            <asp:Label ID="lblManufactureID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ManufactureID") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="ItemID" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <ItemTemplate>
                                            <%-- <asp:Label ID="lblItemID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'></asp:Label>--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="ServiceItem" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblServiceItemID" runat="server" Visible="False" Text='<%# DataBinder.Eval(Container.DataItem,"ServiceItemID") %>'></asp:Label>
                                            <asp:Label ID="lblServicetypename" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Servicetypename") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="SubcategoryName" HeaderText="Subcategory Name">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="200px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="SaleTaxPer" Visible="False">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblSaleTaxPer" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SaleTaxPer") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="GST tax" Visible="False">
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblDrugCategoryID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DrugCategoryMasterID") %>'></asp:Label>
                                            <asp:Label ID="lblIsStockAble" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsStockable") %>'></asp:Label>
                                            <asp:Label ID="lblIGstTax" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IGSTPercent") %>'></asp:Label>
                                            <asp:Label ID="lblSGSTTax" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SGSTPercent") %>'></asp:Label>
                                            <asp:Label ID="lblCGSTTax" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"CGSTPercent") %>'></asp:Label>
                                            <asp:Label ID="lblGSTType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"GSTType") %>'></asp:Label>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Commodity Code">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblCommodityCode" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"CommodityCode") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="VAT Type">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblVatType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"VatType") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="VAT Line">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblVatLine" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"VatLine") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Sale VAT Type">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblSaleVatType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SaleVatType") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Sale VAT Line">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblSaleVatLine" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SaleVatLine") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Sale VAT">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lbSaleVat" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DefaultSaleVatPercentage") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Purchase Vat">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblPurchase" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DefaultPurchaseVatPercentage") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Is Consignment" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsStent" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsStent") %>'></asp:Label>
                                    </ItemTemplate>

                                </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Is CSSD" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsCSSD" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"isCSSDItem") %>'></asp:Label>
                                    </ItemTemplate>

                                </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Is Laundry" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsLaundry" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"isLaundry") %>'></asp:Label>
                                    </ItemTemplate>

                                </asp:TemplateField>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                            <%}else{ %>
                                <asp:GridView ID="grdServiceItemsGST" runat="server" OnSelectedIndexChanged="grdServiceItemsGST_SelectedIndexChanged"
                            CssClass="GridViewStyle" AutoGenerateColumns="False" Width="100%">
                            <Columns>
                                <asp:CommandField ShowSelectButton="True" SelectImageUrl="~/Images/Post.gif" ButtonType="Image" HeaderText="Select">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                </asp:CommandField>
                                <asp:TemplateField HeaderText="Item Name" ItemStyle-Width="250px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemName" Text='<%# DataBinder.Eval(Container.DataItem,"TypeName")%>' runat="server"></asp:Label>
                                        <asp:Label ID="lblSubCatID" Text='<%# DataBinder.Eval(Container.DataItem,"SubID")%>' Visible="false" runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="HSNCode" HeaderText="HSN Code">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ItemCatalog" HeaderText="Item Catalog No." Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ManuFacturer" HeaderText="Manufacturer">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Name" HeaderText="Creater Name">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="200px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="CreaterDateTime" HeaderText="Created Date">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="200px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Description" ItemStyle-Width="250px" HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-CssClass="GridViewItemStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDesc" Text='<%# DataBinder.Eval(Container.DataItem,"Description")%>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Item Code">
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemDose" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemDose")%>' Style="display: none;" ></asp:Label>
                                        <asp:Label ID="lblItemCode" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemCode")%>'></asp:Label>
                                        <asp:Label ID="lblRack" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Rack")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblShelf" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Shelf")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblMaxLevel" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MaxLevel")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblMinLevel" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MinLevel")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblReorderLevel" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ReorderLevel")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblReorderQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ReorderQty")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblMaxReorderQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MaxReorderQty")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblMinReorderQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MinReorderQty")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblPacking" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Packing")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblPurchaseQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"PurchaseQty")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblSaleQty" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SaleQty")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblSaleUnitType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SaleUnitType")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblcheckisexpirable" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsExpirable")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblMajorUnit" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MajorUnit")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblMinorUnit" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MinorUnit")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblCFactor" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ConversionFactor")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblScheduleType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ScheduleType")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblRoute" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Route")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblIsOnSellingPrice" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsOnSellingPrice ")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblSellingMargin" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SellingMargin ")%>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblIsStockable" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsStockable")%>' Visible="false"></asp:Label>
                                        <%--<asp:Label ID="lblIsCSSDItem" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"isCSSDItem")%>' Visible="false"></asp:Label>--%>
                                        <%--<asp:Label ID="lblIsLaundryItem" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"isLaundry")%>' Visible="false"></asp:Label>--%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Is Active">
                                    <ItemTemplate>
                                        <asp:Label ID="lblActive" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsActive")%>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="MajorUnit" HeaderText="Purchase Unit">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="MinorUnit" HeaderText="Sale Unit">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ConversionFactor" HeaderText="Issue Factor">
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="IsUsable" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsUsable" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsUsable") %>'></asp:Label>
                                        <asp:Label ID="lblsubcategoryID" Visible="false" Text='<%# DataBinder.Eval(Container.DataItem,"SubCategoryID") %>' runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="MajorUnit" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblUnitType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"UnitType") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="IsBilled" Visible="false">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblistobill" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"tobebilled") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="TypeID" Visible="False">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblTypeID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Type_id") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ItemID" Visible="False">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblItemID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'></asp:Label>
                                        <asp:Label ID="lblManufactureID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ManufactureID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ServiceItem" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblServiceItemID" runat="server" Visible="False" Text='<%# DataBinder.Eval(Container.DataItem,"ServiceItemID") %>'></asp:Label>
                                        <asp:Label ID="lblServicetypename" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Servicetypename") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="SubcategoryName" HeaderText="Subcategory Name">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="200px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="SaleTaxPer" Visible="False">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblSaleTaxPer" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SaleTaxPer") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="GST tax" Visible="False">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblIGstTax" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IGSTPercent") %>'></asp:Label>
                                        <asp:Label ID="lblSGSTTax" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"SGSTPercent") %>'></asp:Label>
                                        <asp:Label ID="lblCGSTTax" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"CGSTPercent") %>'></asp:Label>
                                        <asp:Label ID="lblGSTType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"GSTType") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Commodity Code">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblCommodityCode" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"CommodityCode") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="50px" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Is Stent" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsStent" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IsStent") %>'></asp:Label>
                                    </ItemTemplate>

                                </asp:TemplateField>
                                 
                                      <asp:TemplateField HeaderText="Is CSSD" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsCSSD" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"isCSSDItem") %>'></asp:Label>
                                    </ItemTemplate>

                                </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Is Laundry" Visible="false">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsLaundry" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"isLaundry") %>'></asp:Label>
                                    </ItemTemplate>

                                </asp:TemplateField>
                                 
                                      
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                            <%} %>
                    </td>
                </tr>
            </table>
  </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3" runat="server" id="divisAsset">
                            <label class="pull-left">
                                Is Asset
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkIsAsset" runat="server" OnCheckedChanged="chkIsAsset_CheckedChanged" AutoPostBack="true" />
                        </div>
                        <br />
                        <br />
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item&nbsp;Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" CssClass="requiredField" runat="server" AutoCompleteType="Disabled" onkeyup="validatespace();"></asp:TextBox>
                            <asp:Label ID="Label9" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                ATC Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtItemCode" runat="server" MaxLength="50">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDesc" runat="server" MaxLength="200"></asp:TextBox>
                            <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                            <asp:TextBox ID="txt_Rusable" runat="server" Visible="False" Style="display: none"> </asp:TextBox>

                            <asp:Button ID="chkDummyItem" runat="server" Visible="false" Text="SearchVendorQuotations"
                                OnClick="chkDummyItem_CheckedChanged" Style="text-align: right;" Width="153px" />
                        </div>

                       
                    </div>
                    <div class="row">
                        
                         <%if (Resources.Resource.IsGSTApplicable == "1"){ %>
                        <div class="col-md-3">
                            <label class="pull-left">
                              Item HSN Code
                            </label>
                        <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtHSNcode" runat="server" MaxLength="50" >
                            </asp:TextBox>
                        </div>
                          <%} %>

                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlServiceItems" runat="server" Width="100px" Enabled="False" Visible="false">
                            </asp:DropDownList>
                            <asp:CheckBox ID="chkIsService" Visible="false" runat="server" Text="IsSrc" OnCheckedChanged="chkIsService_CheckedChanged"
                                AutoPostBack="True" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlGroup" CssClass="requiredField" runat="server" AutoPostBack="false">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Manufacturer
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList CssClass="requiredField" ID="ddlmanufacture" runat="server">
                            </asp:DropDownList>
                            <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Dangerous Drug
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlScheduleType" runat="server">
                                <asp:ListItem Value="0">Select</asp:ListItem>
                                <asp:ListItem Value="1">H1-Schedule Type</asp:ListItem>
                                <asp:ListItem Value="2">H2-Schedule Type</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3" style ="display:none">
                            <label class="pull-left">
                                <span id="spnStrength" runat="server">Strength&nbsp;:</span>
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5"style ="display:none" >
                            <asp:TextBox ID="txtstrength" runat="server"  onkeypress="return checkForSecondDecimal(this,event)" onkeyup="validatedot();" MaxLength="8"></asp:TextBox>
                           <%-- <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server" FilterType="Numbers" InvalidChars="."
                                TargetControlID="txtstrength" />--%>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3" style ="display:none">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkGenric" runat="server" Text="Map Generic" AutoPostBack="true"
                                    OnCheckedChanged="chkGenric_CheckedChanged" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style ="display:none">
                            <asp:DropDownList ID="ddl_salt" runat="server" Style="">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Rack
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRack" runat="server"> </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Shelf
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtShelf" runat="server"> </asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Min. Level
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMinLevel" runat="server"> </asp:TextBox>
                            <%--<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" InvalidChars="."
                                TargetControlID="txtMinLevel" />--%>
                        </div>
                        
                    </div>
                    <div class="row">
                        
                        <div class="col-md-3">
                            <label class="pull-left">
                                Max. Level
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMaxLevel" runat="server"> </asp:TextBox>
                            <%--<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers" InvalidChars="."
                                TargetControlID="txtMaxLevel" />--%>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Reorder&nbsp;Level
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReorderLevel" runat="server"> </asp:TextBox>
                            <%--<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server" FilterType="Numbers" InvalidChars="."
                                TargetControlID="txtReorderLevel" />--%>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Reorder&nbsp;Qty.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReorderQty" runat="server"> </asp:TextBox>
                            <%--<cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server" FilterType="Numbers" InvalidChars="."
                                TargetControlID="txtReorderQty" />--%>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                       
                        <div class="col-md-3"style ="display:none">
                            <label class="pull-left">
                                Dose
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"style ="display:none">
                            <asp:TextBox ID="txtMinReorderQty" runat="server" Style="display: none"> </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server" FilterType="Numbers" InvalidChars="."
                                TargetControlID="txtMinReorderQty" />
                            <asp:TextBox ID="txtDose" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                Packing
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <asp:TextBox ID="txtPacking" runat="server"> </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        
                       
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Purchase&nbsp;Unit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddl_MajorUnit" CssClass="requiredField" runat="server" Width="179px" OnChange="UnitChange();" ClientIDMode="Static">
                            </asp:DropDownList>
                            <input type="button" id="btnPurchaseUnit" tabindex="-1" title="Click To Add Purchase Unit" class="ItDoseButton" value="New" />
                            <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sale Unit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddl_minor" CssClass="requiredField" runat="server" Width="179px" ClientIDMode="Static" OnChange="UnitChange();">
                            </asp:DropDownList>
                            <input type="button" id="btn_Add" tabindex="-1" title="Click To Add New Sale Unit" class="ItDoseButton" value="New" />
                            <asp:Label ID="Label8" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>

                            &nbsp;<cc1:ModalPopupExtender ID="ModalPopupExtender1" BehaviorID="ModalPopupExtender1" runat="server" CancelControlID="btn_unitcancel"
                                TargetControlID="btnHide" OnCancelScript="closeUnit()" PopupControlID="Panel1" DropShadow="true" BackgroundCssClass="filterPupupBackground">
                            </cc1:ModalPopupExtender>
                            <asp:Button ID="btnHide" runat="server" Style="display: none" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Issue Factor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCFactor" runat="server" Width="100%" Style="border-radius: 4px;" CssClass="requiredField" MaxLength="4" TextMode="Number" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;"></asp:Label>
                            <cc1:FilteredTextBoxExtender ID="ftbCFactor" runat="server" FilterType="Numbers,Custom" ValidChars="." TargetControlID="txtCFactor"></cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3"style ="display:none">
                            <label class="pull-left">
                                Commodity Code 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"style ="display:none">
                            <asp:TextBox ID="txtCommodityCode" runat="server" MaxLength="20" ClientIDMode="Static"></asp:TextBox>
                        </div>

                        <%if (Resources.Resource.IsGSTApplicable == "1"){ %>
                        <div class="col-md-3">
                            <label class="pull-left">
                                GST Tax Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                          <asp:RadioButtonList ID="rbtnGst" RepeatDirection="Horizontal" Style="display:none;" runat="server" ClientIDMode="Static">
                                <asp:ListItem Value="IGST">IGST</asp:ListItem>
                                <asp:ListItem Value="CGST&SGST" Selected="True">CGST & SGST</asp:ListItem>
                                <asp:ListItem Value="CGST&UTGST">CGST & UTGST</asp:ListItem>
                            </asp:RadioButtonList>


                            <asp:DropDownList ID="ddlGSTType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlGSTType_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <%} %>

                        <div class="col-md-3"style ="display:none">
                            <label class="pull-left">
                                Is Consignment
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2"style ="display:none">
                            <asp:CheckBox ID="cbIsStent" runat="server" ClientIDMode="Static" />
                        </div>
                         <div class="col-md-3" style ="display:none">
                            <label class="pull-left">
                                Item&nbsp;Catalog&nbsp;No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"style ="display:none">
                            <asp:TextBox ID="txtItemCatalog" runat="server" AutoCompleteType="Disabled" onkeyup="validatespace();" MaxLength="50"> </asp:TextBox>
                        </div>
                        <div class="col-md-3"></div>
                    </div>
                  
                    <div class="row" style="display:none" id="trIGstTax" visible="false" runat="server">
                        <div class="col-md-3">
                            <label class="pull-left">
                                  <%if (Resources.Resource.IsGSTApplicable == "1"){ %> IGST Tax Per. <%} else { %> Tax Per. <%} %>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" id="tdIGstTax">
                            <asp:TextBox ID="txtIGst" ToolTip="Enter IGST" Enabled="false" onlyNumber="5" decimalPlace="2" max-value="100" Width="210px" runat="server">
                            </asp:TextBox>%
                        </div>
                    </div>
                    <div class="row" style="display:none"  <%if (Resources.Resource.IsGSTApplicable == "0"){ %> style="display:none;" <%} %>>
                        
                        <div class="col-md-8" id="trPartialCgstTax" runat="server">
                            <label class="pull-left">
                                CGST Tax Per.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>:</b>
                            </label>
                            <asp:TextBox ID="txtCGst" Width="210px" Enabled="false" onlyNumber="6" decimalPlace="2" max-value="100" ToolTip="Enter CGST"
                                CssClass="ItDoseTextinputNum " Style="margin-left: 17px;" runat="server"></asp:TextBox>%
                        </div>
                        <div class="col-md-8" id="trPartialSgstTax" clientidmode="Static" runat="server">
                            <label class="pull-left">
                                SGST Tax Per.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<b>:</b>
                            </label>
                            <asp:TextBox ID="txtSGst" Width="209px" Enabled="false" onlyNumber="6" decimalPlace="2" max-value="100" ToolTip="Enter SGST"
                                CssClass="ItDoseTextinputNum" Style="margin-left: 13px;" runat="server"></asp:TextBox>%
                        </div>
                        <div class="col-md-9" id="trPartialUTGSUTax" clientidmode="Static" runat="server" visible="false">
                            <label class="pull-left">
                                UTGST Tax Per.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<b>:</b>
                            </label>
                            <asp:TextBox ID="txtUTGST" runat="server" Enabled="false" Width="209px" onlyNumber="6" decimalPlace="2" max-value="100" ToolTip="Enter UTGST"
                                CssClass="ItDoseTextinputNum" Style="margin-left: 13px;"></asp:TextBox>%
                        </div>
                        

                        <%--<div class="col-md-3">
                            <label class="pull-left">
                                Is Asset
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkIsAsset" runat="server" />
                        </div>--%>
                        
                    </div>

                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <%--Is On Selling Price--%>
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlIsOnSellingPrice" Style="display: none;" runat="server" ClientIDMode="Static">
                                <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">

                            <label class="pull-left">
                                <%--Selling Margin(%)--%>
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSellingMarginPer" Style="display: none;" onlyNumber="6" decimalPlace="2" max-value="100" ToolTip="Enter Margin(%)"
                                CssClass="ItDoseTextinputNum" runat="server" Text="0.00"></asp:TextBox>
                        </div>

                    </div>


                    <div class="row" >
                        <div class="col-md-3">

                            <label class="pull-left">
                                Drug Category
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ID="ddlDrugCategory" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                       
                        <div class="col-md-3">
                            <label class="pull-left">
                                Item Type :
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlItemType" runat="server">
                                <asp:ListItem Value="0">Select</asp:ListItem>
                                <asp:ListItem Value="Vital">Vital</asp:ListItem>
                                <asp:ListItem Value="Essential">Essential</asp:ListItem>
                                <asp:ListItem Value="Deseriable">Deseriable</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        
                    </div>

                    <%--Adding two flag i.e IsCssd,IsLaundry By Amit Baranwal(21-08-2020)--%>
                         

                    <div class="row">
                        <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                        <div class="col-md-3" style="">
                            <label class="pull-left">
                               Default Pur.VAT %
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtPurchase" runat="server"> </asp:TextBox>
                        </div>
                        

                        <div class="col-md-3" style="">
                            <label class="pull-left">
                            Sale VAT Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ID="ddlSaleVatType" ClientIDMode="Static"></asp:DropDownList>
                            <asp:DropDownList runat="server" ID="ddlSaleVatLine" Style="display: none;" ClientIDMode="Static"></asp:DropDownList>
                        </div>

                        <div class="col-md-3" style="">
                            <label class="pull-left">
                               Sale VAT %
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                            <asp:TextBox ID="txtSale" runat="server"> </asp:TextBox>
                        </div>
                        <%} %>
                    </div>
                    <div class="row">
                        <%if (Resources.Resource.IsGSTApplicable == "0"){ %>
                        <div class="col-md-3" style="">
                            <label class="pull-left">
                               Pur. VAT Line
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ID="ddlVATLine" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        
                        <div class="col-md-3" style="">
                            <label class="pull-left">
                                Pur.VAT Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ID="ddlVATType" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Stock Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ID="ddlIsStockAble">
                                <asp:ListItem Text="Stockable" Value="1" />
                                <asp:ListItem Text="Non-Stockable" Value="0" />
                            </asp:DropDownList>
                        </div>
                        <%} %>
                        <div class="row">
                            <div class="col-md-3">
                            <label class="pull-left">
                               Expirable
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                             <div class="col-md-5" >
                            <asp:CheckBox ID="chkIsExpirable" runat="server"
                                Width="140px" />
                                   <asp:CheckBox Checked="true" ID="chkIsActive" runat="server"
                                Text="Active" Visible="False" />
                        </div>                      
                        <div class="col-md-3">

                            <label class="pull-left">
                                Is CSSD
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                        <asp:CheckBox ID="ChkIsCSSD" runat="server" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Is Laundry
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="ChkIsLaundry" runat="server" ClientIDMode="Static" />
                        </div>                       
                        <div class="col-md-8">                            
                        </div> 
                              <div class="col-md-3">
                            <asp:CheckBox ID="chkIsTrigger" runat="server" Text="Is Trigger"
                                Width="116px" />
                        </div>
                       
                    </div>
                         <div class="row">
                            <div class="col-md-3">
                                Item Dose
                            </div>
                              <div class="col-md-5">
                                  <asp:TextBox ID="txtItemDose" runat="server" ClientIDMode="Static" class="allow_decimal" ></asp:TextBox>
                            </div>
                             </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table style="width: 100%; border-collapse: collapse">
                    <tr style="display: none">
                        <td style="width: 68px; text-align: right;">Item For Dept. 
                        </td>
                        <td colspan="7">
                            <asp:RadioButtonList ID="rdoItemType" runat="server"
                                RepeatDirection="Horizontal" OnSelectedIndexChanged="rdoItemType_SelectedIndexChanged1">

                                <asp:ListItem Text="HOSPITAL STORE" Value="0" Selected="True">
                                </asp:ListItem>

                            </asp:RadioButtonList>
                        </td>
                        <td style="width: 204px;"></td>
                    </tr>
                    <tr>
                        <td style="width: 68px; text-align: right; display: none;">
                            <asp:Label ID="lblToBilled" runat="server" Text="To be Billed :" Width="88px" Visible="true"> </asp:Label>
                        </td>
                        <td style="width: 298px; display: none;" colspan="4">
                            <asp:CheckBox ID="chkBilled" runat="server" Text="ToBilled" Checked="false" Visible="true"
                                OnCheckedChanged="chkBilled_CheckedChanged" />
                        </td>
                        <td style="width: 299px">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="4"></td>
                        <td style="text-align: right; display: none;" colspan="2">Item Type :&nbsp;</td>
                        <td style="width: 288px;">
                            <asp:TextBox ID="txtMaxReorderQty" runat="server" Style="display: none;"> </asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server" FilterType="Numbers" InvalidChars="."
                                TargetControlID="txtMaxReorderQty" />
                            <asp:DropDownList ID="ddlMedicineType" Visible="false" runat="server">
                            </asp:DropDownList>
                            <asp:Label ID="Label3" runat="server" Visible="false" Style="color: Red; font-size: 10px;">*</asp:Label></td>
                        <td style="width: 204px"></td>
                    </tr>
                    <tr>
                        <td style="width: 298px" colspan="2"></td>
                        <td style="text-align: right; display: none;" colspan="2">Route :&nbsp;</td>
                        <td style="width: 288px">
                            <asp:DropDownList ID="ddlRoute" Visible="false" runat="server"></asp:DropDownList>
                        </td>
                        <td style="width: 204px"></td>
                    </tr>
                    <tr style="display: none;">
                        <td style="width: 68px; text-align: right;">ReUsable/NonReUsable:
                        </td>
                        <td style="width: 298px;" colspan="4">
                            <asp:RadioButtonList ID="rdoUsabletype" runat="server" OnClick="txtvisble()" CssClass="ItDoseRadiobuttonlist"
                                RepeatDirection="Horizontal" Width="179px">
                                <asp:ListItem Selected="True" Text="NonReusable" Value="NR">
                                </asp:ListItem>
                                <asp:ListItem Text="ReUsable" Value="R">
                                </asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td id="tdlbl" style="width: 93px" colspan="2">
                            <asp:Label ID="lbl_ServiceName" Text="Service Name:" runat="server"></asp:Label>
                        </td>
                        <td id="tdtxt" style="width: 288px">
                            <asp:TextBox ID="txtRusable" runat="server"> </asp:TextBox>
                        </td>
                        <td style="width: 204px;"></td>
                    </tr>
                    <tr>
                        <td style="width: 116px; margin-left: 40px;">
                            <asp:CheckBox ID="chkIsEffectingInventory" runat="server" AutoPostBack="True" CssClass="ItDoseCheckbox"
                                OnCheckedChanged="chkIsEffectingInventory_CheckedChanged" Text="Is Effecting Inventory"
                                Width="34px" Checked="True" Visible="False" />
                        </td>
                        <td colspan="6" style="text-align: center;">
                            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click" 
                                Text="Save" OnClientClick="return Validate()" />
                            &nbsp;&nbsp;&nbsp;
                            <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" OnClick="btnCancel_Click"
                                Text="Cancel" />
                        </td>
                        <td style="width: 74px">
                            <asp:TextBox ID="txtBilling" runat="server" Width="3px"
                                Visible="False"> </asp:TextBox><asp:TextBox ID="txtStartTime" runat="server"
                                    Width="3px" Visible="False"></asp:TextBox><asp:TextBox ID="txtPulse" runat="server"
                                        Width="3px" Visible="False"></asp:TextBox><asp:TextBox
                                            ID="txtBufferTime" runat="server" Width="3px"
                                            Visible="False"></asp:TextBox><asp:TextBox ID="txtEndTime" runat="server"
                                                Width="3px" Visible="False"></asp:TextBox>
                        </td>

                    </tr>
                    <tr>
                        <td style="width: 288px"></td>
                        <td colspan="7" style="text-align: left">
                            <a style="font-weight: bold;" href="../Store/ManufactureMaster.aspx?Mode=1" target="_blank"
                                onclick="wopen('../Store/ManufactureMaster.aspx?Mode=1', 'popup1', 980, 400); return false;">Create New Manufacturer</a> &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;
                            <asp:LinkButton ID="lnkNewItems" runat="server" Text="Refresh Manufacturer List" Font-Bold="True"
                                OnClick="lnkNewItems_Click" />
                            &nbsp; &nbsp; &nbsp;
                            <a style="font-weight: bold; float: left; padding-right: 20px;" href="../Store/DrugCategoryMaster.aspx?Mode=1" target="_blank" onclick="wopen('../Store/DrugCategoryMaster.aspx?Mode=1', 'popup1', 1300, 400); return false;">Create Drug Category</a>
                            <asp:LinkButton ID="lnkbtnUnit" runat="server" Text="Refresh Unit" Font-Bold="True"
                                OnClick="lnkbtnUnit_Click" Style="display: none;" />
                            &nbsp; &nbsp; &nbsp; &nbsp;
                        </td>

                        <td style="width: 204px"></td>
                    </tr>
                </table>

            </div>
        </div>
        <script type="text/javascript">
            function rblSelectedValue() {
                //Get the radiobuttonlist reference
                var radio = document.getElementById("<%= rdoUsabletype.ClientID %>");

                //local variable to store selectedvalue
                var selectedvaluer = radio.rows.length;

                //loop through the items in radiobuttonlist
                for (var j = 0; j < radio.length; j++) {
                    if (radio[j].checked) {
                        selectedvalue = radio[j].value;
                        alert(selectedvalue);
                    }
                }
            }

            function alt() {
                alert("hi");
            }
            function txtvisble() {
                var rdoUsabletype = document.getElementById("<%=rdoUsabletype.ClientID %>");
                if (rdoUsabletype.rows[0].cells[1].firstChild.checked == true) {
                    document.getElementById("<%=lbl_ServiceName.ClientID %>").style.display = "block";
                    document.getElementById("<%=txtRusable.ClientID %>").style.display = "block";
                }
                else {
                    document.getElementById("<%=lbl_ServiceName.ClientID %>").style.display = "none";
                    document.getElementById("<%=txtRusable.ClientID %>").style.display = "none";
                }
            }
            function valdte() {
                var mjor = document.getElementById("<%=ddl_MajorUnit.ClientID %>").value;
                var rdoUsabletype = document.getElementById("<%=rdoUsabletype.ClientID %>");
                var txtreusable;
                if (rdoUsabletype.rows[0].cells[1].firstChild.checked == true) {
                    txtreusable = document.getElementById("<%=txtRusable.ClientID%>").value;

                if (txtreusable == "") {
                    alert("Service Name can't be blank !");
                    return false;
                    txtreusable.focus();
                }
            }
            if (mjor == "") {
                alert("Purchase Unit can't be blank !");
                return false;
                mjor.focus();

            }
            return true;
        }
        function closeUnit() {
            $find('ModalPopupExtender1').hide();
            $("#txt_AddUnit").val('');
            $("#ddlFormula").prop('selectedIndex', 0);
            $("#lblErroeFormula").text('');
        }

        function validateFormula() {
            if ($.trim($("#txt_AddUnit").val()) == "") {
                $("#lblErroeFormula").text('Please Enter Sale Unit');
                $("#txt_AddUnit").focus();
                return false;
            }

        }
        $(function () {
            $("#btn_Add").bind("click", function () {
                $find('ModalPopupExtender1').show();
                $("#txt_AddUnit").focus();

            });



        });
        </script>

        <asp:Panel ID="Panel1" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="340px" Height="120px">
            <div class="Purchaseheader">
                Create Sale Unit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closeUnit()" />

                  to close</span></em>
            </div>

            <table style="width: 100%">
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Label ID="lblErroeFormula" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Sale Unit :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txt_AddUnit" CssClass="requiredField" ClientIDMode="Static" runat="server" onkeypress="return check(event)" MaxLength="20">
                        </asp:TextBox>&nbsp;<span style="color: Red; font-size: 9px;"></span>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Button ID="btn_addunit" runat="server" OnClientClick="return validateFormula()" CssClass="ItDoseButton" Text="Save" OnClick="btn_addunit_Click" />
                        &nbsp;<asp:Button ID="btn_unitcancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
                    </td>

                </tr>

            </table>

        </asp:Panel>
        <asp:Panel ID="pnlnewtest" Width="700px" Height="200px" runat="server" CssClass="pnlOrderItemsFilter"
            Style="display: none" BorderStyle="None" ScrollBars="Auto">
            <div id="div1" class="modalPopup">
                <div class="POuter_Box_Inventory">
                    <div class="content" style="text-align: center;">
                        <b>Search Vendor Quotation Items</b>
                        <br />
                        <asp:Label ID="lblMsgQuot" runat="server" CssClass="ItDoseLblError" EnableViewState="false" />
                    </div>
                </div>
                <div class="POuter_Box_Inventory">
                    <asp:Label ID="lblMsgDummy" runat="server" CssClass="ItDoseLblError" EnableViewState="false">
                    </asp:Label>
                    <table>
                        <tr>
                            <td>
                                <label>
                                    Search Items :</label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtSearchItem" runat="server">
                                </asp:TextBox>
                                <asp:Button ID="btnsearch" runat="server" Text="Search" OnClick="btnsearch_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:GridView ID="grdItemDummy" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Select">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" runat="server" />
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="ConfigRelation" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblConfigID" runat="server" Text='<%#Eval("ConfigID") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="ConfigRelation" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblID" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="ConfigName" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblConfigName" runat="server" Text='<%#Eval("ConfigName") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Category">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCategory" runat="server" Text='<%#Eval("Category") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="SubCategory">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSubCategory" runat="server" Text='<%#Eval("SubCategory") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="ItemName">
                                            <ItemTemplate>
                                                <asp:Label ID="lblItemName" runat="server" Text='<%#Eval("ItemName") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="CatID" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCategoryID" runat="server" Text='<%#Eval("Categoryid") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="SubCatID" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSubCatID" runat="server" Text='<%#Eval("subcategoryid") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="ItemId" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblItemId" runat="server" Text='<%#Eval("ItemId") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>

                                        <%--   <asp:TemplateField HeaderText="VAT Type" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblType" runat="server" Text='<%#Eval("VatType") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="VAT Line" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblLine" runat="server" Text='<%#Eval("VatLine") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="350px" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>--%>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </div>
                <br />
                <div class="content">
                    <table>
                        <tr>
                            <td colspan="4" style="text-align: center;">
                                <strong>Would you Like To Include The Following Also</strong>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:CheckBox ID="chkvendormaster" runat="server" Text="VendorMaster" />
                            </td>
                            <td>
                                <asp:CheckBox ID="chkitemmaster" runat="server" Text="ItemMaster" />
                            </td>
                            <td>
                                <asp:CheckBox ID="chSalt" runat="server" Text="SaltMaster" />
                            </td>
                            <td>
                                <asp:CheckBox ID="chkManu" runat="server" Text="Company" />
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="text-align: center;">
                    <asp:Button ID="btnsaveDummy" runat="server" Text="Save" OnClick="btnsaveDummy_Click" CssClass="ItDoseButton" />
                    <asp:Button ID="btnCancelDummy" runat="server" Text="Cancel" CssClass="ItDoseButton" />
                </div>
            </div>
        </asp:Panel>
        <div style="display: none;">
            <asp:Button ID="Button1" runat="server" CssClass="ItDoseButton" />
        </div>
        <cc1:ModalPopupExtender ID="mpedummy" TargetControlID="Button1" PopupControlID="pnlnewtest"
            runat="server" DropShadow="true" CancelControlID="btnCancelDummy" BackgroundCssClass="filterPupupBackground"
            X="150" Y="50">
        </cc1:ModalPopupExtender>

        <cc1:ModalPopupExtender ID="ModalPopupExtender2" BehaviorID="ModalPopupExtender2" TargetControlID="Button1" PopupControlID="pnlPurchase"
            runat="server" DropShadow="true" OnCancelScript="closePurchaseUnit()" CancelControlID="btnPurchaseCancel" BackgroundCssClass="filterPupupBackground">
        </cc1:ModalPopupExtender>

        <asp:Panel ID="pnlPurchase" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none"
            Width="750px" Height="250px">
            <div class="Purchaseheader">
                Create Purchase Unit&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor: pointer" onclick="closePurchaseUnit()" />

                  to close</span></em>
            </div>

            <table style="width: 100%">
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Label ID="lblPurchaseUnit" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Purchase Unit :&nbsp;
                    </td>
                    <td style="text-align: left">
                        <asp:TextBox ID="txtPurchaseUnit" CssClass="requiredField" Width="240px" ClientIDMode="Static" runat="server" onkeypress="return check(event)" MaxLength="20"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:Button ID="btnPurchaseUnitSave" runat="server" OnClientClick="return validatePurchaseFormula()" CssClass="ItDoseButton" Text="Save" OnClick="btnPurchaseUnitSave_Click" />
                        &nbsp;<asp:Button ID="btnPurchaseCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
                    </td>

                </tr>

            </table>

        </asp:Panel>


        <script type="text/javascript">
            $(function () {
                $("#btnPurchaseUnit").click(function () {
                    $find("ModalPopupExtender2").show();
                    $("#txtPurchaseUnit").focus();
                });
            });

            function closePurchaseUnit() {
                $find("ModalPopupExtender2").hide();
                $("#txtPurchaseUnit").val('');
                $("#lblPurchaseUnit").text('');
            }

            function validatePurchaseFormula() {

                if ($.trim($("#txtPurchaseUnit").val()) == "") {
                    $("#lblPurchaseUnit").text('Please Enter Purchase Unit');
                    $("#txtPurchaseUnit").focus();
                    return false;
                }
            }
            function pageLoad(sender, args) {
                if (!args.get_isPartialLoad()) {
                    $addHandler(document, "keydown", onKeyDown);
                }
            }
            function onKeyDown(e) {
                if (e && e.keyCode == Sys.UI.Key.esc) {

                    if ($find('ModalPopupExtender1')) {
                        closeUnit();

                    }
                    if ($find('ModalPopupExtender2')) {
                        closePurchaseUnit();

                    }
                }
            }
            $(document).ready(function () {
                // $('#trIGstTax').hide();
                $('#<%=rbtnGst.ClientID%>').change(function () {
                    if ($('#<%=rbtnGst.ClientID%> input[type="radio"]:checked').val() == "IGST") {
                        $('#trIGstTax').show();
                        $('#trIGstTax').closest('td').find('tdIGstTax').css('width', '200px');
                        $('#trPartialCgstTax').hide();
                        $('#trPartialSgstTax').hide();
                        $('#trPartialUTGSUTax').hide();

                    }
                    else if ($('#<%=rbtnGst.ClientID%> input[type="radio"]:checked').val() == "CGST&UTGST") {
                        $('#trIGstTax').hide();
                        $('#trPartialCgstTax').show();
                        $('#trPartialSgstTax').hide();
                        $('#trPartialUTGSUTax').show();
                    }
                    else {
                        $('#trIGstTax').hide();
                        $('#trPartialCgstTax').show();
                        $('#trPartialSgstTax').show();
                        $('#trPartialUTGSUTax').hide();
                    }

                    $("#<%=txtCGst.ClientID%>").val('0.00');
                    $("#<%=txtSGst.ClientID%>").val('0.00');
                    $("#<%=txtIGst.ClientID%>").val('0.00');
                    $("#<%=txtUTGST.ClientID%>").val('0.00');
                });
            });
            function checkGstType() {
                if ($('#<%=rbtnGst.ClientID%> input[type="radio"]:checked').val() == "IGST") {
                    $('#trIGstTax').show();
                    $('#trIGstTax').closest('td').find('tdIGstTax').css('width', '200px');
                    $('#trPartialCgstTax').hide();
                    $('#trPartialSgstTax').hide();

                }
                else {
                    $('#trIGstTax').hide();
                    $('#trPartialCgstTax').show();
                    $('#trPartialSgstTax').show();
                }
            }



            $(function () {

                AllowDecimal();
            });

            function AllowDecimal() {
                $(".allow_decimal").bind("change keyup input", function () {
                    var position = this.selectionStart - 1;
                    //remove all but number and .
                    var fixed = this.value.replace(/[^0-9\.]/g, "");
                    if (fixed.charAt(0) === ".")
                        //can't start with .
                        fixed = fixed.slice(1);

                    var pos = fixed.indexOf(".") + 1;
                    if (pos >= 0)
                        //avoid more than one .
                        fixed = fixed.substr(0, pos) + fixed.slice(pos).replace(".", "");

                    if (this.value !== fixed) {
                        this.value = fixed;
                        this.selectionStart = position;
                        this.selectionEnd = position;
                    }
                });
            }

        </script>
</asp:Content>
