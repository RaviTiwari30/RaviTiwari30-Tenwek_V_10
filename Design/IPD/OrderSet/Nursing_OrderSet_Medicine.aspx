<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Nursing_OrderSet_Medicine.aspx.cs"
    Inherits="Design_IPD_OrderSet_Nursing_OrderSet_Medicine" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link rel="stylesheet" href="../../../Styles/PurchaseStyle.css" id="styleSheet"/>
    <script type="text/javascript"  src="../../../Scripts/Search.js"></script>
    <script src="../../../Scripts/jquery-1.7.1.min.js" type="text/javascript" ></script>
     <script type="text/javascript" src="../../../Scripts/Message.js"></script>
    <script type="text/javascript" >
        $(document).ready(function () {

            var width = window.screen.availWidth;
            var height = screen.height;

            if (screen.width > 1024) {

                $("link#styleSheet").attr("href", "../../../Styles/OrderSet_1366.css");
            }
            else if (screen.width <= 1024) {

                $("link#styleSheet").attr("href", "../../../Styles/OrderSet_1024.css");

            }
        });
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

                    //listbox.options[0].selected=true;
                }

            }
        }

        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                //alert(textbox2.value);
                //var f = document.theSource;
                //var listbox = f.measureIndx;
                //var textbox = f.measure_name;
                var listbox = listbox2;
                var textbox = textbox2;

                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m;
                //alert(listbox.selectedIndex);
                //int len = eval(listbox.selectedIndex);
                //alert(len);
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
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).text().length > charlimit) {
                $(id).text($(id).text().substring(0, charlimit));
                //            $("#divmessage").html("Maximum cahracter allowes :" + charlimit);
            }
        }

        var keys = [];
        var values = [];

        $(document).ready(function () {
            var options = $('#<% = lstInv.ClientID %> option');
            $.each(options, function (index, item) {
                values.push(item.innerHTML);
            });

            $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 38 || key == 40) {
                    var index = $('#<% = lstInv.ClientID %>').get(0).selectedIndex;
                    if (key == 38) {
                        $('#<% = lstInv.ClientID %> option:nth-child(' + (index) + ')').attr('selected', 'selected');
                    }
                    else if (key == 40) {
                        $('#<% = lstInv.ClientID %> option:nth-child(' + (index + 1) + ')').attr('selected', 'selected');
                    }
                    $('#<% = txtSearch.ClientID %>').val($('#<% = lstInv.ClientID %> option:nth-child(' + (index + 1) + ')').text());
                }
                else {
                    var filter = $(this).val();
                    if (filter == '') {
                        $('#<% = lstInv.ClientID %> option:nth-child(1)').attr('selected', 'selected')
                        return;
                    }

                    DoListBoxFilter('#<% = lstInv.ClientID %>', '#<% = txtSearch.ClientID %>', '0', filter, values, key);
                }


            });
            $('#<%=txtcpt.ClientID %>').bind("keyup keydown", function (e) {
                if ($('#<%=txtcpt.ClientID %>').val().length > "0") {
                    $('#<% = txtSearch.ClientID %>').val('');
                }
                var key = (e.keyCode ? e.keyCode : e.charCode);
                var filter = $(this).val();
                if (filter == '') {
                    $('#<% = lstInv.ClientID %> option:nth-child(1)').attr('selected', 'selected')
                    return;
                }
                DoListBoxFilter('#<% = lstInv.ClientID %>', '#<% = txtcpt.ClientID %>', '1', filter, values, key);
            });


            $('#<% = txtSearch.ClientID %>,#<% = lstInv.ClientID %>').keydown(function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 13) {
                    e.preventDefault();
                    var index = $('#<% = lstInv.ClientID %>').get(0).selectedIndex;
                    if (index == -1) {
                        $('#<% = lblMsg.ClientID %>').text('Please Select an Investigation');
                        return;
                    }
                    $('#<% = txtSearch.ClientID %>').val('');
                    $('#<% = lstInv.ClientID %> option:nth-child(1)').attr('selected', 'selected')

                }

                else if (key == 38 || key == 40) {
                    var index = $('#<% = lstInv.ClientID %>').get(0).selectedIndex;
                    if (key == 38) {
                        $('#<% = lstInv.ClientID %> option:nth-child(' + (index) + ')').attr('selected', 'selected');
                        $('#<% = txtSearch.ClientID %>').val($('#<% = lstInv.ClientID %> option:nth-child(' + (index) + ')').text());
                    }
                    else if (key == 40) {
                        $('#<% = lstInv.ClientID %> option:nth-child(' + (index + 1) + ')').attr('selected', 'selected');
                        $('#<% = txtSearch.ClientID %>').val($('#<% = lstInv.ClientID %> option:nth-child(' + (index + 2) + ')').text());
                    }


                }
            });


        });


        function DoListBoxFilter(listBoxSelector, textbox, searchtype, filter, values, key) {
            var list = $(listBoxSelector);

            var selectBase = '<option value="{0}">{1}</option>';
            //          list.empty();

            if (searchtype == "0") {

                for (i = 0; i < values.length; ++i) {
                    var value = '';

                    if (values[i].indexOf('#') == -1)
                        continue;
                    else
                        value = values[i].split('#')[1].trim();
                    var len = $(textbox).val().length;
                    if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                        $('#<% = lstInv.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
                        return;
                    }
                }
            }
            else if (searchtype == "1") {
                for (i = 0; i < values.length; ++i) {
                    var value = '';
                    if (values[i].indexOf('#') == -1)
                        value = values[i];
                    else
                        value = values[i].split('#')[0].trim();
                    var len = $(textbox).val().length;
                    if (value.substring(0, len).toLowerCase() == filter.toLowerCase()) {
                        $('#<% = lstInv.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
                        return;
                    }
                }
            }
            else if (searchtype == "2") {
                if (key == 39) {

                    var index = list.get(0).selectedIndex;

                    for (i = index + 1; i < values.length; ++i) {
                        var value = values[i];
                        if (value.toLowerCase().match(filter.toLowerCase())) {
                            list.attr('selectedIndex', i);
                            return;

                        }

                    }
                }
                else {
                    for (i = 0; i < values.length; ++i) {
                        var value = values[i];

                        if (value.toLowerCase().match(filter.toLowerCase())) {
                            // list.attr('selectedIndex', i);
                            $('#<% = lstInv.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
                            return;

                            //                    var temp = '<option value="'+keys[i]+'">'+value+'</option>' ;
                            //                    list.append(temp);
                        }

                    }
                }
            }

            $(textbox).focus();

        }

        function validate() {
            if ($("#<%=lstInv.ClientID %> option:selected").text() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Medicine');
                return false;
            }
            if ($("#<%=ddldose.ClientID %> option:selected").text() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Dose');
                $("#<%=ddldose.ClientID %> ").focus();
                return false;
            }
            if ($("#<%=ddlTime.ClientID %> option:selected").text() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Time');
                $("#<%=ddlTime.ClientID %> ").focus();
                return false;
            }
            if ($("#<%=ddlDays.ClientID %> option:selected").text() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Days');
                $("#<%=ddlDays.ClientID %>").focus();
                return false;
            }
        }
        function disable() {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style=" text-align: center">
            <b>&nbsp;Medicine</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; ">
            <table border="0" cellpadding="0" cellspacing="0" style=" text-align: left">
                <tr style="display: none">
                    <td style="text-align: left" colspan="11">
                        <asp:Label ID="lblWeight" runat="server" CssClass="ItDoseLabelBl"></asp:Label>
                        <asp:Button ID="btnNewMed" runat="server" Text="New Medicine" CssClass="ItDoseButton"
                            Width="128px" ToolTip="Enter To Add New Medicine" OnClick="btnNewMed_Click" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        Medicine&nbsp;Name&nbsp;:&nbsp;
                    </td>
                    <td colspan="4">
                        <asp:TextBox ID="txtSearch" runat="server" Width="360px" onKeyDown="MoveUpAndDownText(txtSearch,lstInv);"
                            onKeyUp="suggestName(txtSearch,lstInv);" TabIndex="1" ToolTip="Enter To Search" />
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td colspan="4">
                        Item&nbsp;Code&nbsp;:&nbsp;
                        <asp:TextBox ID="txtcpt" runat="server" Width="108px" onkeyup="javascript:ValidateCharactercount(10,this);" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                    <td colspan="4">
                        &nbsp;
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td colspan="4">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 4%; text-align: left">
                    </td>
                    <td valign="top" style="text-align: right">
                        Medicine :&nbsp;
                    </td>
                    <td colspan="9">
                        <asp:ListBox ID="lstInv" runat="server" Width="457px" Height="121px"></asp:ListBox>
                        <span style="color: Red; font-size: 8px">*</span>
                        <asp:Button ID="btnNew" runat="server" Text="Add Medicine" CssClass="ItDoseButton"
                            Visible="false" ToolTip="Click To Add Medicine" OnClick="btnNew_Click" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 4%; text-align: left">
                    </td>
                    <td style="text-align: left" class="style2">
                        &nbsp;
                    </td>
                    <td colspan="5">
                        &nbsp;
                    </td>
                    <td style="width: 10%">
                    </td>
                    <td style="width: 14%">
                    </td>
                    <td class="">
                    </td>
                    <td style="width: 43%">
                    </td>
                </tr>
                <tr>
                    <td style="width: 4%; text-align: left">
                    </td>
                    <td style="text-align: right">
                        Dose :&nbsp;
                    </td>
                    <td>
                        <asp:DropDownList ID="ddldose" runat="server" Width="70px" ToolTip="Select Dose"
                            TabIndex="2">
                        </asp:DropDownList>
                        <asp:Label ID="Label8" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                    <td align="right">
                        Times :&nbsp;
                    </td>
                    <td align="left">
                        <asp:DropDownList ID="ddlTime" runat="server" Width="70px" ToolTip="Select Time"
                            TabIndex="3">
                        </asp:DropDownList>
                        <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                    <td colspan="5">
                        Duration :&nbsp;
                    </td>
                    <td style="width: 43%">
                        <asp:DropDownList ID="ddlDays" runat="server" Width="59px" ToolTip="Select Days"
                            TabIndex="4">
                        </asp:DropDownList>
                        <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 4%; text-align: left">
                    </td>
                    <td style="text-align: right">
                        Remark :&nbsp;
                    </td>
                    <td colspan="9" style="width: 14%">
                        <asp:TextBox ID="txtRemarks" runat="server" Width="393px" TabIndex="5" MaxLength="100"
                            ToolTip="Enter Remarks" />&nbsp;
                        <asp:Button ID="btnAdd" Text="Add" runat="server" CssClass="ItDoseButton" TabIndex="6"
                            OnClientClick="return validate();" ToolTip="Click To Add" OnClick="btnAdd_Click" />
                        <asp:Label ID="lblDoctor" runat="server" Visible="False"></asp:Label>
                    </td>
                </tr>
            </table>
            <div class="Purchaseheader" style="text-align: left;">
                &nbsp;Medicines</div>
            <div style="text-align: center">
                <asp:GridView ID="grdMedicine" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdMedicine_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText=" S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Medicine Name" HeaderStyle-Width="250px" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblMedicine" runat="server" Text='<%#Eval("Medicine") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Dose" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblDose" runat="server" Text=' <%#Eval("Dose")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Times" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblTimes" runat="server" Text=' <%#Eval("Time") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Duration" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblDays" runat="server" Text=' <%#Eval("Days") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remark" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:Label ID="lblRemarks" runat="server" Text=' <%#Eval("Remarks")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Outsource">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="chkPrint" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reject" HeaderStyle-Width="45px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgRemove" runat="server" ImageUrl="~/Images/Delete.gif" CommandName="imbRemove"
                                    CommandArgument='<%#Container.DataItemIndex %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ID" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <asp:Label ID="lblid" Visible="false" runat="server" Text='<%# Eval("MedicineID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" Visible="False"
                    TabIndex="7" ToolTip="Click To Save" OnClick="btnSave_Click" UseSubmitBehavior ="false" OnClientClick="disable();" />
            </div>
        </div>
        <asp:Panel ID="pnlItem" Width="400px" Height="100px" runat="server" CssClass="pnlRequestItemsFilter"
            Style="display: none">
            <div class="Purchaseheader" runat="server" id="dragHandle">
                Add Items
            </div>
            <div style="display: none">
                <asp:Button ID="btnItem" Text="Item" runat="Server" CssClass="ItDoseButton" />
            </div>
            <div>
                <label class="forItemLabel">
                    Item :</label>
                <asp:DropDownList ID="ddlItems" runat="server" Width="350px" />
                <br />
                <asp:Button ID="btnSaveMed" runat="server" Text="Save" CssClass="ItDoseButton" Width="75px"
                    OnClick="btnSaveMed_Click" />
                <asp:Button ID="btnCancel" Text="Cancel" runat="server" CssClass="ItDoseButton" Width="75px" />
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeItems" runat="server" CancelControlID="btnCancel"
            DropShadow="true" TargetControlID="btnItem" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlItem" PopupDragHandleControlID="dragHandle" />
        <asp:Panel ID="pnlMed" Width="460px" Height="100px" runat="server" CssClass="pnlRequestItemsFilter"
            Style="display: none">
            <div class="Purchaseheader" runat="server" id="Div1">
                Add New Medicine&nbsp;</div>
            <div style="display: none">
                <asp:Button ID="btnNM" Text="Item" runat="server" CssClass="ItDoseButton" />
            </div>
            <div style="text-align: right;">
            </div>
            <div>
                <label class="forItemLabel">
                    &nbsp;Medicine :</label>
                <asp:TextBox ID="txtMedicine" runat="server" Width="240px" MaxLength="100"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqMedicine" ErrorMessage="Enter Medicine Name" runat="server"
                    ValidationGroup="SaveNM" ControlToValidate="txtMedicine"></asp:RequiredFieldValidator>
                <br />
                <br />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnSaveNM" runat="server" Text="Save" CssClass="ItDoseButton" Width="75px"
                    OnClick="btnSaveNM_Click" ValidationGroup="SaveNM" />&nbsp;
                <asp:Button ID="btnCancelMed" Text="Cancel" runat="server" CssClass="ItDoseButton"
                    Width="75px" />
                &nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblMedicine" runat="server" CssClass="ItDoseLblError"
                    Style="float: 9px; font-weight: normal;" />
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender ID="mpeNewMed" runat="server" CancelControlID="btnCancelMed"
            DropShadow="true" TargetControlID="btnNM" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlMed" PopupDragHandleControlID="dragHandle" />
    </div>
    </form>
</body>
</html>
