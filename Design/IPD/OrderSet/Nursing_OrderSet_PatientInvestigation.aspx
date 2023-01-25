<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Nursing_OrderSet_PatientInvestigation.aspx.cs"
    Inherits="Design_IPD_OrderSet_Nursing_OrderSet_PatientInvestigation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <link href="../../../Styles/PurchaseStyle.css" rel="stylesheet" id="styleSheet" type="text/css" />
    <script type="text/javascript"  src="../../../Scripts/Search.js"></script>
    <script src="../../../Scripts/jquery-1.7.1.min.js" type="text/javascript" ></script>
    <script type="text/javascript" src="../../../Scripts/Message.js" ></script>
    <script type="text/javascript" >
        $(document).ready(function () {
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
            $('#<%=txtRemarks.ClientID %>').focus();
        });
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).text().length > charlimit) {
                $(id).text($(id).text().substring(0, charlimit));
                $("#divmessage").html("Maximum text length allowed is :" + charlimit);
            }
            else
                $("#divmessage").html("");
        }
        $(document).ready(function () {
            var MaxLength = 200;
            $("#<% =txtRemarks.ClientID %>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $('#<%=txtRemarks.ClientID%>').keypress(function (e) {
                if ($(this).val().length >= MaxLength) {
                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });
        function ClickSelectbtn(e, btnName) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
            if (window.event.keyCode == 13) {
                var btn = document.getElementById(btnName);
                alert(btn);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                    return false;
                }
            }
        }

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
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
    </script>
    <style type="text/css">
        .style1
        {
            width: 145px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="sm1" runat="server" />
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Investigation Prescription</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            <asp:Label ID="lblDoctorID" runat="server" Visible="False"></asp:Label></div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Investigation Prescription
            </div>
            <table>
                <tr>
                    <td style="text-align: right; width:145px">
                    Sub-Category :&nbsp;</td>
                    <td style="width:100px">
                    <asp:DropDownList ID="ddlsubcategory" runat="server" Width="155px" 
                        onselectedindexchanged="ddlsubcategory_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                    </td>
                    <td style="width:125px; text-align: right;">
                        &nbsp;</td>
                    <td style="width:70px">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align: right;" class="style1">
                        Investigation&nbsp;Name&nbsp;:
                    </td>
                    <td style="width: 320px" colspan="2">
                        <asp:TextBox ID="txtSearch" runat="server" Width="320px" onKeyDown="MoveUpAndDownText(txtSearch,lstInv);"
                            onKeyUp="suggestName(txtSearch,lstInv);" CssClass="ItDoseTextinputText" TabIndex="1"
                            ToolTip="Enter To Search" />
                    </td>
                    <td style="width: 305px">
                        CPT&nbsp;Code&nbsp;:&nbsp;
                        <asp:TextBox ID="txtcpt" runat="server" Width="118px" onkeyup="javascript:ValidateCharactercount(10,this);" />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td class="style1">
                        &nbsp;
                    </td>
                    <td style="vertical-align: top" colspan="3">
                        <asp:ListBox ID="lstInv" runat="server" Width="451px" Height="125px" CssClass="ItDoseDropdownbox" />
                    </td>
                    <tr>
                        <td style="vertical-align: top; text-align: right;" class="style1">
                            Remarks :
                        </td>
                        <td colspan="3">
                            <asp:TextBox ID="txtRemarks" ClientIDMode="Static" runat="server" TextMode="MultiLine"
                                MaxLength="200" Width="445px" onkeyup="javascript:ValidateCharactercount(200,this);">
                            </asp:TextBox>
                            <asp:Button ID="btnSelect" CausesValidation="false" runat="server" CssClass="ItDoseButton"
                                Text="Add" TabIndex="2" ToolTip="Click To Add" OnClick="btnSelect_Click" />
                        </td>
                    </tr>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Patient Prescribed Investigation
            </div>
            <div style="text-align: center;">
                <asp:GridView ID="grdItemRate" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                    OnRowCommand="grdItemRate_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Investigation Name">
                            <ItemTemplate>
                                <%# Eval("Item") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Date") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remarks">
                            <ItemTemplate>
                                <asp:Label ID="lblRemarks" runat="server" Text='<%# Eval("Remarks")%>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Outsource">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <asp:CheckBox ID="chkPrint" runat="server" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                    CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ID" Visible="false">
                            <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                            <ItemTemplate>
                                <asp:Label ID="lblvalue" Visible="false" runat="server" Text='<%# Eval("ItemID") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; ">
            &nbsp;<asp:Button ID="btnSave" Text="Save" runat="server" CssClass="ItDoseButton"
                CausesValidation="False" ToolTip="Click To Save" OnClick="btnSave_Click" UseSubmitBehavior="false"
                OnClientClick="validate();" />
        </div>
    </div>
    </form>
</body>
</html>
