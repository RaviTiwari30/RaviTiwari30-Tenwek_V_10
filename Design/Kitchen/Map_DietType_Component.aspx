<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Map_DietType_Component.aspx.cs" Inherits="Design_Kitchen_Map_DiteType_Control" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript">
        function Check_Click(objRef) {
            var row = objRef.parentNode.parentNode;
            var GridView = row.parentNode;
            var inputList = GridView.getElementsByTagName("input");
            for (var i = 0; i < inputList.length; i++) {
                var headerCheckBox = inputList[0];
                var checked = true;
                if (inputList[i].type == "checkbox" && inputList[i] != headerCheckBox) {
                    if (!inputList[i].checked) {
                        checked = false;
                        break;
                    }
                }
            }
            headerCheckBox.checked = checked;
        }
    </script>

    <script type="text/javascript">
        function checkAll(objRef) {
            var GridView = objRef.parentNode.parentNode.parentNode;
            var inputList = GridView.getElementsByTagName("input");
            for (var i = 0; i < inputList.length; i++) {
                var row = inputList[i].parentNode.parentNode;
                if (inputList[i].type == "checkbox" && objRef != inputList[i]) {
                    if (objRef.checked) {
                        inputList[i].checked = true;
                    }
                    else {
                        inputList[i].checked = false;
                    }
                }
            }
        }

        $(document).ready(function () {
            $("[id*=chkAll]").live("click", function () {
                var chkHeader = $(this);
                var grid = $(this).closest("table");
                $("input[type=checkbox]", grid).each(function () {
                    if (chkHeader.is(":checked")) {
                        $(this).attr("checked", "checked");
                        var td = $("td", $(this).closest("tr"));
                        td.css({ "background-color": "#A1DCF2" });
                        $("input[type=text]", td).removeAttr("disabled");
                    } else {
                        $(this).removeAttr("checked");
                        var td = $("td", $(this).closest("tr"));
                        td.css({ "background-color": "#FFF" });
                        $("input[type=text]", td).attr("disabled", "disabled");
                    }
                });
            });

            $("[id*=chk]").live("click", function () {
                var grid = $(this).closest("table");
                var chkHeader = $("[id*=chkAll]", grid);
                if (!$(this).is(":checked")) {
                    var td = $("td", $(this).closest("tr"));
                    td.css({ "background-color": "#FFF" });
                    chkHeader.removeAttr("checked");
                    $("input[type=text]", td).attr("disabled", "disabled");
                    $("input[type=text]", td[9]).val('0');
                    $(this).closest("tr").find("input[id*=txtQty]").val('0');
                    totalCalories();
                } else {

                    var td = $("td", $(this).closest("tr"));
                    td.css({ "background-color": "#A1DCF2" });
                    $("input[type=text]", td).removeAttr("disabled");
                    if ($("[id*=chk]", grid).length == $("[id*=chk]:checked", grid).length)
                        chkHeader.attr("checked", "checked");
                    $(this).closest("tr").find("input[id*=txtQty]").val('1');
                    totalCalories();

                }

            });
            totalCalories();

            function totalCalories() {
                var totalcalories = 0;
                var totalprotien = 0;
                var totalsodium = 0;
                var totalpotassium = 0;
                var totalsaturatedfat = 0;
                var value = 0;
                var totalFatVal = 0;
                var totalCalciumVal = 0;
                var totalIronVal = 0;
                var totalZincVal = 0;
                $("#<%=grdDetail.ClientID%> tr:has(td)").each(function () {
                    if ($(this).closest("tr").find("input[id*=chk]").is(":checked")) {
                        var calvalue = parseFloat($(this).closest("tr").find("input[id*=txtCaloriesSum]").val());
                        var protienvalue = $(this).closest("tr").find("input[id*=txtProteinSum]").val();
                        var sodiumvalue = $(this).closest("tr").find("input[id*=txtSodiumSum]").val();
                        var potassiumvalue = $(this).closest("tr").find("input[id*=txtPotassiumSum]").val();
                        var SaturatedFatvalue = $(this).closest("tr").find("input[id*=txtSaturatedFatSum]").val();
                        var FatVal = $(this).closest("tr").find("input[id*=txtTFatVal]").val();
                        var CalciumVal = $(this).closest("tr").find("input[id*=txtCalciumVal]").val();
                        var IronVal = $(this).closest("tr").find("input[id*=txtIronVal]").val();
                        var ZincVal = $(this).closest("tr").find("input[id*=txtZincVal]").val();

                        if (calvalue != '0' && calvalue != " " && calvalue != null) {
                            totalcalories += Number(calvalue);
                        }
                        if (protienvalue != '0' && protienvalue != " " && protienvalue != null) {
                            totalprotien += Number(protienvalue);
                        }
                        if (sodiumvalue != '0' && sodiumvalue != " " && sodiumvalue != null) {
                            totalsodium += Number(sodiumvalue);
                        }
                        if (potassiumvalue != '0' && potassiumvalue != " " && potassiumvalue != null) {
                            totalpotassium += Number(potassiumvalue);
                        }
                        if (SaturatedFatvalue != '0' && SaturatedFatvalue != " " && SaturatedFatvalue != null) {
                            totalsaturatedfat += Number(SaturatedFatvalue);
                        }
                        if (FatVal != '0' && FatVal != " ") {
                            totalFatVal += Number(FatVal);
                        }
                        if (CalciumVal != '0' && CalciumVal != " " && CalciumVal != null) {
                            totalCalciumVal += Number(CalciumVal);
                        }
                        if (IronVal != '0' && IronVal != " " && IronVal != null) {
                            totalIronVal += Number(IronVal);
                        }
                        if (ZincVal != '0' && ZincVal != " " && ZincVal != null) {
                            totalZincVal += Number(ZincVal);
                        }
                    }
                });
                if (isNaN(totalcalories)) totalcalories = 0;
                if (isNaN(totalprotien)) totalprotien = 0;
                if (isNaN(totalsodium)) totalsodium = 0;
                if (isNaN(totalpotassium)) totalpotassium = 0;
                if (isNaN(totalsaturatedfat)) totalsaturatedfat = 0;
                if (isNaN(totalFatVal)) totalFatVal = 0;
                if (isNaN(totalCalciumVal)) totalCalciumVal = 0;
                if (isNaN(totalIronVal)) totalIronVal = 0;
                if (isNaN(totalZincVal)) totalZincVal = 0;
                $('#<%=lblCaloriesTotal.ClientID %>').text(precise_round(totalcalories, 2));
                $('#<%=lblProteinTotal.ClientID %>').text(precise_round(totalprotien, 2));
                $('#<%=lblSodiumTotal.ClientID %>').text(precise_round(totalsodium, 2));
                $('#<%=lblPotassiumTotal.ClientID %>').text(precise_round(totalpotassium, 2));
                $('#<%=lblSaturatedFat.ClientID %>').text(precise_round(totalsaturatedfat, 2));
                $('#<%=lblTFatVal.ClientID %>').text(precise_round(totalFatVal, 2));
                $('#<%=lblCalciumVal.ClientID %>').text(precise_round(totalCalciumVal, 2));
                $('#<%=lblIronVal.ClientID %>').text(precise_round(totalIronVal, 2));
                $('#<%=lblZincVal.ClientID %>').text(precise_round(totalZincVal, 2));

            }
            $("table[id*=grdDetail] input[type=text][id*=txtQty]").bind("keyup", function () {

                if (($(this).closest("tr").find("input[id*=txtQty]").val() == "0") || ($(this).closest("tr").find("input[id*=txtQty]").val() == "")) {
                    $(this).closest("tr").find("input[id*=txtQty]").val('0');
                }
                $(this).closest("tr").find("input[id*=txtQty]").val(Number($(this).closest("tr").find("input[id*=txtQty]").val()));
                var totalCalories = 0;
                var qty = parseFloat($(this).val());
                if (isNaN(qty)) qty = 1;
                var Calories = parseFloat($(this).closest("tr").find("input[id*=txtCalories]").val());
                $(this).closest("tr").find("input[id*=txtCaloriesSum]").val(qty * Calories);
                $("input[id*=txtCaloriesSum]").each(function (index, item) {
                    tempCalories = parseFloat($(item).val());
                    if (isNaN(tempCalories)) tempCalories = 0;
                    totalCalories = totalCalories + tempCalories;
                });
                totalCalories = precise_round(totalCalories, 2);
                $('#<%=lblCaloriesTotal.ClientID %>').text(totalCalories);

                var totalProtein = 0;
                var Protein = parseFloat($(this).closest("tr").find("input[id*=txtProtein]").val());
                $(this).closest("tr").find("input[id*=txtProteinSum]").val(qty * Protein);
                $("input[id*=txtProteinSum]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    totalProtein = totalProtein + tempAmount;
                });
                totalProtein = precise_round(totalProtein, 2);
                $('#<%=lblProteinTotal.ClientID %>').text(totalProtein);

                var totalSodium = 0;
                var Sodium = parseFloat($(this).closest("tr").find("input[id*=txtSodium]").val());
                $(this).closest("tr").find("input[id*=txtSodiumSum]").val(qty * Sodium);
                $("input[id*=txtSodiumSum]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    totalSodium = totalSodium + tempAmount;

                });
                totalSodium = precise_round(totalSodium, 2);
                $('#<%=lblSodiumTotal.ClientID %>').text(totalSodium);

                var totalpotassium = 0;
                var potassium = parseFloat($(this).closest("tr").find("input[id*=txtPotassium]").val());
                $(this).closest("tr").find("input[id*=txtPotassiumSum]").val(qty * potassium);
                $("input[id*=txtPotassiumSum]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    totalpotassium = totalpotassium + tempAmount;

                });
                totalpotassium = precise_round(totalpotassium, 2);
                $('#<%=lblPotassiumTotal.ClientID %>').text(totalpotassium);

                var totalSaturatedFat = 0;
                var SaturatedFat = parseFloat($(this).closest("tr").find("input[id*=txtSaturatedFat]").val());
                $(this).closest("tr").find("input[id*=txtSaturatedFatSum]").val(qty * SaturatedFat);
                $("input[id*=txtSaturatedFatSum]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    totalSaturatedFat = totalSaturatedFat + tempAmount;

                });
                totalSaturatedFat = precise_round(totalSaturatedFat, 2);
                $('#<%=lblSaturatedFat.ClientID %>').text(totalSaturatedFat);

                var totalT_Fat = 0;
                var T_Fat = parseFloat($(this).closest("tr").find("input[id*=txtT_Fat]").val());
                $(this).closest("tr").find("input[id*=txtTFatVal]").val(qty * T_Fat);
                $("input[id*=txtTFatVal]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    totalT_Fat = totalT_Fat + tempAmount;

                });
                totalT_Fat = precise_round(totalT_Fat, 2);
                $('#<%=lblTFatVal.ClientID %>').text(totalT_Fat);

                var totalCalcium = 0;
                var Calcium = parseFloat($(this).closest("tr").find("input[id*=txtCalcium]").val());
                $(this).closest("tr").find("input[id*=txtCalciumVal]").val(qty * Calcium);
                $("input[id*=txtCalciumVal]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    totalCalcium = totalCalcium + tempAmount;

                });
                totalCalcium = precise_round(totalCalcium, 2);
                $('#<%=lblCalciumVal.ClientID %>').text(totalCalcium);

                var totalIron = 0;
                var Iron = parseFloat($(this).closest("tr").find("input[id*=txtIron]").val());
                $(this).closest("tr").find("input[id*=txtIronVal]").val(qty * Iron);
                $("input[id*=txtIronVal]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    totalIron = totalIron + tempAmount;

                });
                totalIron = precise_round(totalIron, 2);
                $('#<%=lblIronVal.ClientID %>').text(totalIron);

                var totaZinc = 0;
                var Zinc = parseFloat($(this).closest("tr").find("input[id*=txtZinc]").val());
                $(this).closest("tr").find("input[id*=txtZincVal]").val(qty * Zinc);
                $("input[id*=txtZincVal]").each(function (index, item) {
                    tempAmount = parseFloat($(item).val());
                    if (isNaN(tempAmount)) tempAmount = 0;
                    totaZinc = totaZinc + tempAmount;

                });
                totaZinc = precise_round(totaZinc, 2);
                $('#<%=lblZincVal.ClientID %>').text(totaZinc);
            });
        });
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function validate() {
            if ($("#<%=ddltiming.ClientID%>").val() == "Select") {
                $("#<%=lblmsg.ClientID%>").text("Please Select Diet Timing ");
                $("#<%=ddltiming.ClientID%>").focus();
                return false;
            }
            if ($("#<%=ddlmenu.ClientID%>").val() == "Select") {
                $("#<%=lblmsg.ClientID%>").text("Please Select Menu Name");
                $("#<%=ddlmenu.ClientID%>").focus();
                return false;
            }
            if ($("#<%=ddlDietType.ClientID%>").val() == "Select") {
                $("#<%=lblmsg.ClientID%>").text("Please Select Diet Type");
                $("#<%=ddlDietType.ClientID%>").focus();
                return false;
            }

            if ($("#<%=ddlSubDietType.ClientID%>").val() == "Select") {
                $("#<%=lblmsg.ClientID%>").text("Please Select Diet Specification");
                $("#<%=ddlSubDietType.ClientID%>").focus();
                return false;
            }
        }
        function disabledBtn(btn) {

            btn.disabled = true;
            btn.value = 'Submitting....';
            if ($("#<%=btnSave.ClientID%>").is(':visible'))
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
    </script>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Map Diet Component Master<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Map</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Timing
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddltiming" runat="server" AutoPostBack="true"
                                CssClass="requiredField" OnSelectedIndexChanged="ddltiming_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Type 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList CssClass="requiredField" AutoPostBack="true" ID="ddlDietType" runat="server" OnSelectedIndexChanged="ddlDietType_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Specification
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList AutoPostBack="true" ID="ddlSubDietType" runat="server" CssClass="requiredField" OnSelectedIndexChanged="ddlSubDietType_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Menu Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlmenu" runat="server" AutoPostBack="true" CssClass="requiredField" Enabled="false"
                                OnSelectedIndexChanged="ddlmenu_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row" style="text-align: center;">
                        <asp:Button ID="btnSearch" runat="server" OnClientClick="return validate()" Text="Search" CssClass="ItDoseButton" OnClick="btnSearch_Click" />
                        <asp:Label ID="lblMenuID" runat="server" Visible="false"></asp:Label>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-21">
                            <asp:Label ID="lblcal" runat="server" Text="Calories" ForeColor="Tomato"></asp:Label>&nbsp;&nbsp;
                        <asp:Label ID="lblCaloriesTotal" runat="server" Text="0" ForeColor="SlateBlue"></asp:Label>
                            &nbsp;&nbsp;&nbsp;<asp:Label ID="lblpro" runat="server" Text="Protein" ForeColor="Tomato"></asp:Label>&nbsp;&nbsp;
                        <asp:Label ID="lblProteinTotal" runat="server" Text="0" ForeColor="SlateBlue"></asp:Label>
                            &nbsp;&nbsp;&nbsp;<asp:Label ID="lblSod" runat="server" Text="Sodium" ForeColor="Tomato"></asp:Label>&nbsp;&nbsp;
                        <asp:Label ID="lblSodiumTotal" runat="server" Text="0" ForeColor="SlateBlue"></asp:Label>
                             &nbsp;&nbsp;&nbsp;<asp:Label ID="lblPotassium" runat="server" Text="Potassium" ForeColor="Tomato"></asp:Label>&nbsp;&nbsp;
                        <asp:Label ID="lblPotassiumTotal" runat="server" Text="0" ForeColor="SlateBlue"></asp:Label>
                            &nbsp;&nbsp;&nbsp;<asp:Label ID="lblSat" runat="server" Text="Saturated Fat" ForeColor="Tomato"></asp:Label>&nbsp;&nbsp;
                        <asp:Label ID="lblSaturatedFat" runat="server" Text="0" ForeColor="SlateBlue"></asp:Label>
                            &nbsp;&nbsp;&nbsp;<asp:Label ID="lblTFat" runat="server" Text="TFat" ForeColor="Tomato"></asp:Label>&nbsp;&nbsp;
                        <asp:Label ID="lblTFatVal" runat="server" Text="0" ForeColor="SlateBlue"></asp:Label>
                            &nbsp;&nbsp;&nbsp;<asp:Label ID="lblCalcium" runat="server" Text="Calcium" ForeColor="Tomato"></asp:Label>&nbsp;&nbsp;
                        <asp:Label ID="lblCalciumVal" runat="server" Text="0" ForeColor="SlateBlue"></asp:Label>
                            &nbsp;&nbsp;&nbsp;<asp:Label ID="lblIron" runat="server" Text="Iron" ForeColor="Tomato"></asp:Label>&nbsp;&nbsp;
                        <asp:Label ID="lblIronVal" runat="server" Text="0" ForeColor="SlateBlue"></asp:Label>
                            &nbsp;&nbsp;&nbsp;<asp:Label ID="lblZinc" runat="server" Text="Zinc" ForeColor="Tomato"></asp:Label>&nbsp;&nbsp;
                        <asp:Label ID="lblZincVal" runat="server" Text="0" ForeColor="SlateBlue"></asp:Label>
                        </div>
                    </div>
                    <div class="row"></div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="Purchaseheader">Details</div>
            <div class="" style="text-align: center; max-height: 400px; overflow-X: hidden; overflow-Y: auto;">
                <asp:GridView ID="grdDetail" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdDetail_RowDataBound">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkAll" runat="server" onclick="checkAll(this);"></asp:CheckBox>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chk" runat="server" onclick="Check_Click(this)"></asp:CheckBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component Name">
                            <ItemTemplate>
                                <asp:Label ID="lblCompID" runat="server" Visible="false" Text='<%#Eval("ComponentID") %>'></asp:Label>
                                <asp:Label ID="lblName" runat="server" Text='<%#Eval("Name") %>'></asp:Label>
                                <asp:Label ID="lblDietID" runat="server" Visible="true" Text='<%#Eval("SubDietID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <asp:Label ID="lblType" runat="server" Text='<%#Eval("Type") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Unit">
                            <ItemTemplate>
                                <asp:Label ID="lblUnit" runat="server" Text='<%#Eval("Unit") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Calories (Kcal)">
                            <ItemTemplate>
                                <asp:Label ID="lblCalories" runat="server" Text='<%#Eval("Calories") %>'></asp:Label>
                                <asp:TextBox ID="txtCalories" runat="server" Text='<%#Eval("Calories") %>' Style="display: none"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Protein (g)">
                            <ItemTemplate>
                                <asp:Label ID="lblProtein" runat="server" Text='<%#Eval("Protein") %>'></asp:Label>
                                <asp:TextBox ID="txtProtein" runat="server" Text='<%#Eval("Protein") %>' Style="display: none"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Sodium (g)">
                            <ItemTemplate>
                                <asp:Label ID="lblSodium" runat="server" Text='<%#Eval("Sodium") %>'></asp:Label>
                                <asp:TextBox ID="txtSodium" runat="server" Text='<%#Eval("Sodium") %>' Style="display: none"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Potassium (g)">
                            <ItemTemplate>
                                <asp:Label ID="lblPotassium" runat="server" Text='<%#Eval("Potassium") %>'></asp:Label>
                                <asp:TextBox ID="txtPotassium" runat="server" Text='<%#Eval("Potassium") %>' Style="display: none"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Saturated Fat (g)">
                            <ItemTemplate>
                                <asp:Label ID="lblSaturatedFat" runat="server" Text='<%#Eval("SaturatedFat") %>'></asp:Label>
                                <asp:TextBox ID="txtSaturatedFat" runat="server" Text='<%#Eval("SaturatedFat") %>' Style="display: none"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="TFat (g)">
                            <ItemTemplate>
                                <asp:Label ID="lblT_Fat" runat="server" Text='<%#Eval("T_Fat") %>'></asp:Label>
                                <asp:TextBox ID="txtT_Fat" runat="server" Text='<%#Eval("T_Fat") %>' Style="display: none"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Calcium (mg)">
                            <ItemTemplate>
                                <asp:Label ID="lblCalcium" runat="server" Text='<%#Eval("Calcium") %>'></asp:Label>
                                <asp:TextBox ID="txtCalcium" runat="server" Text='<%#Eval("Calcium") %>' Style="display: none"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Iron (mg)">
                            <ItemTemplate>
                                <asp:Label ID="lblIron" runat="server" Text='<%#Eval("Iron") %>'></asp:Label>
                                <asp:TextBox ID="txtIron" runat="server" Text='<%#Eval("Iron") %>' Style="display: none"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Zinc (mg)">
                            <ItemTemplate>
                                <asp:Label ID="lblZinc" runat="server" Text='<%#Eval("Zinc") %>'></asp:Label>
                                <asp:TextBox ID="txtZinc" runat="server" Text='<%#Eval("Zinc") %>' Style="display: none"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Qty.">
                            <ItemTemplate>
                                <asp:TextBox ID="txtQty" Width="30px" AutoCompleteType="Disabled" runat="server" Text='<%#Eval("Qty") %>' Enabled="false"></asp:TextBox>
                                <asp:TextBox ID="txtCaloriesSum" runat="server" Style="display: none" Text='<%# Util.GetString((Util.GetDecimal(Eval("Qty")))*Util.GetDecimal(Eval("Calories"))) %>'></asp:TextBox>
                                <asp:TextBox ID="txtProteinSum" runat="server" Style="display: none" Text='<%# Util.GetString((Util.GetDecimal(Eval("Qty")))*Util.GetDecimal(Eval("Protein"))) %>'></asp:TextBox>
                                <asp:TextBox ID="txtSodiumSum" runat="server" Style="display: none" Text='<%# Util.GetString((Util.GetDecimal(Eval("Qty")))*Util.GetDecimal(Eval("Sodium"))) %>'></asp:TextBox>
                                <asp:TextBox ID="txtPotassiumSum" runat="server" Style="display: none" Text='<%# Util.GetString((Util.GetDecimal(Eval("Qty")))*Util.GetDecimal(Eval("Potassium"))) %>'></asp:TextBox>
                                <asp:TextBox ID="txtSaturatedFatSum" runat="server" Style="display: none" Text='<%# Util.GetString((Util.GetDecimal(Eval("Qty")))*Util.GetDecimal(Eval("SaturatedFat"))) %>'></asp:TextBox>
                                <asp:TextBox ID="txtTFatVal" runat="server" Style="display: none" Text='<%# Util.GetString((Util.GetDecimal(Eval("Qty")))*Util.GetDecimal(Eval("T_Fat"))) %>'></asp:TextBox>
                                <asp:TextBox ID="txtCalciumVal" runat="server" Style="display: none" Text='<%# Util.GetString((Util.GetDecimal(Eval("Qty")))*Util.GetDecimal(Eval("Calcium"))) %>'></asp:TextBox>
                                <asp:TextBox ID="txtIronVal" runat="server" Style="display: none" Text='<%# Util.GetString((Util.GetDecimal(Eval("Qty")))*Util.GetDecimal(Eval("Iron"))) %>'></asp:TextBox>
                                <asp:TextBox ID="txtZincVal" runat="server" Style="display: none" Text='<%# Util.GetString((Util.GetDecimal(Eval("Qty")))*Util.GetDecimal(Eval("Zinc"))) %>'></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Previous Qty.">
                            <ItemTemplate>
                                <asp:Label ID="lblPreviousQty" Width="30px" runat="server" Text='<%#Eval("Qty") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSave" CssClass="ItDoseButton" runat="server" Text="Save Map" Visible="false" OnClick="btnSave_Click" OnClientClick="disabledBtn(this)" />

        </div>
    </div>
</asp:Content>
