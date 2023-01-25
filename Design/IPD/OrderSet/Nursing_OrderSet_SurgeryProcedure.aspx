<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Nursing_OrderSet_SurgeryProcedure.aspx.cs"
    Inherits="Design_IPD_OrderSet_Nursing_OrderSet_SurgeryProcedure" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link id="styleSheet" rel="Stylesheet" href="../../../Styles/PurchaseStyle.css" type="text/css" /> 
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>
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
//            if ($('link[href="../../../Styles/OrderSet_1020.css"]').size() > 0) { alert('loaded') }
//            if ($('link[href="../../../Styles/OrderSet_1366.css"]').size() > 0) { alert('loaded1') }
//            if ($('link[href="../../../Styles/PurchaseStyle.css"]').size() > 0) { alert('loaded2') }
        
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).text().length > charlimit) {
                $(id).text($(id).text().substring(0, charlimit));
                $("#divmessage").html("Maximum text length allowed is :" + charlimit);
            }
            else
                $("#divmessage").html("");
        }
        
        
    </script>
    <script type="text/javascript">

        var keys = [];
        var values = [];

        $(document).ready(function () {

            var options = $('#<% = lstSurgery.ClientID %> option');
            $.each(options, function (index, item) {
                values.push(item.innerHTML);
            });

            $('#<% = txtWord.ClientID %>').keyup(function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 38 || key == 40) {
                    var index = $('#<% = lstSurgery.ClientID %>').get(0).selectedIndex;
                    if (key == 38) {
                        $('#<% = lstSurgery.ClientID %> option:nth-child(' + (index) + ')').attr('selected', 'selected');
                    }
                    else if (key == 40) {
                        $('#<% = lstSurgery.ClientID %> option:nth-child(' + (index + 1) + ')').attr('selected', 'selected');
                    }
                    $('#<% = txtWord.ClientID %>').val($('#<% = lstSurgery.ClientID %> option:nth-child(' + (index + 1) + ')').text());
                }
                else {
                    var filter = $(this).val();
                    if (filter == '') {
                        $('#<% = lstSurgery.ClientID %> option:nth-child(1)').attr('selected', 'selected')
                        return;
                    }

                    DoListBoxFilter('#<% = lstSurgery.ClientID %>', '#<% = txtWord.ClientID %>', '0', filter, values, key);
                }


            });
            $('#<%=txtSurgeryCode.ClientID %>').bind("keyup keydown", function (e) {
                if ($('#<%=txtSurgeryCode.ClientID %>').val().length > "0") {
                    $('#<% = txtWord.ClientID %>').val('');
                }
                var key = (e.keyCode ? e.keyCode : e.charCode);
                var filter = $(this).val();
                if (filter == '') {
                    $('#<% = lstSurgery.ClientID %> option:nth-child(1)').attr('selected', 'selected')
                    return;
                }
                DoListBoxFilter('#<% = lstSurgery.ClientID %>', '#<% = txtSurgeryCode.ClientID %>', '1', filter, values, key);
            });


            $('#<% = txtWord.ClientID %>,#<% = lstSurgery.ClientID %>').keydown(function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 13) {
                    e.preventDefault();
                    var index = $('#<% = lstSurgery.ClientID %>').get(0).selectedIndex;
                    if (index == -1) {
                        $('#<% = lblMsg.ClientID %>').text('Please Select an Investigation');
                        return;
                    }
                    $('#<% = txtWord.ClientID %>').val('');
                    $('#<% = lstSurgery.ClientID %> option:nth-child(1)').attr('selected', 'selected')

                }

                else if (key == 38 || key == 40) {
                    var index = $('#<% = lstSurgery.ClientID %>').get(0).selectedIndex;
                    if (key == 38) {
                        $('#<% = lstSurgery.ClientID %> option:nth-child(' + (index) + ')').attr('selected', 'selected');
                        $('#<% = txtWord.ClientID %>').val($('#<% = lstSurgery.ClientID %> option:nth-child(' + (index) + ')').text());
                    }
                    else if (key == 40) {
                        $('#<% = lstSurgery.ClientID %> option:nth-child(' + (index + 1) + ')').attr('selected', 'selected');
                        $('#<% = txtWord.ClientID %>').val($('#<% = lstSurgery.ClientID %> option:nth-child(' + (index + 2) + ')').text());
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
                        $('#<% = lstSurgery.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
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
                        $('#<% = lstSurgery.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
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
                            $('#<% = lstSurgery.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
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
</head>
<body>
    <form id="form1" runat="server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory" >
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Surgery Prescription</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader" style="text-align: left;">
                Surgery Prescription</div>
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td style="width: 15%" align="right">
                        CPT CODE :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtSurgeryCode" runat="server" onkeyup="javascript:ValidateCharactercount(10,this);"
                            Width="123px" ToolTip="Enter CPT Code To Search Surgery" TabIndex="1"></asp:TextBox>
                    </td>
                    <td style="text-align: right;">
                        &nbsp;
                    </td>
                    <td style="text-align: left;" width="60%">
                        &nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;" width="15%">
                        Search&nbsp;By&nbsp;Word&nbsp;:&nbsp;
                    </td>
                    <td colspan="2">
                        <asp:TextBox ID="txtWord" runat="server" AutoCompleteType="Disabled" CssClass="ItDoseTextinputText"
                            Width="290px" ToolTip="Enter Word To Search Surgery" TabIndex="2"></asp:TextBox>
                        &nbsp;&nbsp;
                        <asp:Button ID="btnWord" runat="server" CssClass="ItDoseButton" Text="Search" ToolTip="Click To Search"
                            TabIndex="3" OnClick="btnWord_Click1" />
                        &nbsp;
                    </td>
                    <td style="text-align: left;" width="60%">
                        &nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;&nbsp;&nbsp;<asp:ListBox ID="lstSurgery" TabIndex="4" runat="server" CssClass="ItDoseDropdownbox"
                            OnRowCommand="grdItemDetails_RowCommand" Width="612px" Height="119px"></asp:ListBox>
                    </td>
                    <td align="left">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnAddItem"
                            runat="server" Text="Add " CssClass="ItDoseButton" ToolTip="Click To Add" TabIndex="4"
                            OnClick="btnAddItem_Click" />
                    </td>
                    
                </tr>
                <tr align="center">
                    <td colspan="2" rowspan="4">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:GridView ID="grdItemDetails" runat="server" AutoGenerateColumns="False" HorizontalAlign="Center"
                            CssClass="GridViewStyle" Width="630px" OnRowCommand="grdItemDetails_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="5px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Surgery" HeaderStyle-Width="240px" 
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSurgery" runat="server" Text='<%#Eval("SurgeryID") %>' Visible="false"></asp:Label>
                                        <asp:Label ID="lblSurgeryName" runat="server" Text='<%#Eval("SurgeryName") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" Width="240px" HorizontalAlign="Left" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Qty" HeaderStyle-Width="5px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:Label ID="lblQty" runat="server" Text='<%#Eval("Qty") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Remove" HeaderStyle-Width="5px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbRemove" ToolTip="Remove Item" runat="server" ImageUrl="~/Images/Delete.gif"
                                            CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory" >
            <div style="text-align: center;">
                <asp:Button ID="btnSave" runat="server" Text="Save" ValidationGroup="save" UseSubmitBehavior ="false" OnClientClick="validate();"
                    ToolTip="Click To Save" TabIndex="5" OnClick="btnSave_Click" CssClass="ItDoseButton" />
            </div>
        </div>
    </div>
    </form>
</body>
</html>
