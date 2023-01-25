<%@ Page Language="C#" MaintainScrollPositionOnPostback="true" AutoEventWireup="true"
    CodeFile="Mortuary_BasketBilling.aspx.cs" Inherits="Design_Mortuary_Mortuary_BasketBilling" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
      <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

</head>
<body>
    <script type="text/javascript">
        if ($.browser.msie) {
            $(document).on("keydown", function (e) {
                var doPrevent;
                if (e.keyCode == 8) {
                    var d = e.srcElement || e.target;
                    if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                        doPrevent = d.readOnly
                            || d.disabled;
                    }
                    else
                        doPrevent = true;
                }
                else
                    doPrevent = false;
                if (doPrevent) {
                    e.preventDefault();
                }
            });
        }
    </script>
    <script type="text/javascript">
        function chkValidation() {
            if (($.trim($("#<%=txtQty.ClientID%>").val()) == "") || ($.trim($("#<%=txtQty.ClientID%>").val()) < "0")) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Quantity');
                $("#<%=txtQty.ClientID%>").focus();
                return false;
            }

            if ($("#<%=ListBox1.ClientID%>").val() == null) {
                $("#<%=lblMsg.ClientID%>").text('Please Select Services');
                $("#<%=ListBox1.ClientID%>").focus();
                alert('');
                return false;
            }

            if ($("#<%=ListBox1.ClientID%>").val().split('#')[4] == "1") {

                var Ok = confirm('This Item is Non Payable.Do You Want To Prescribe');
                if (Ok) {
                    __doPostBack('btnSelect', '');
                }
                else {
                    return false;
                }
            }
        }
        function RestrictDoubleEntry(btn) {
            if (Page_IsValid) {
                btn.disabled = true;
                btn.value = 'Submitting...';
                __doPostBack('btnReceipt', '');
            }
        }
        $(document).ready(function () {
            $('#txtsearchword').keyup("keyup keydown", function (e) {
                $("#ListBox1 option").remove();
                var lstInvestigation = $("#ListBox1");
                $.ajax({
                    url: "../Common/CommonService.asmx/IpdServices",
                    data: '{ Typename: "' + $("#txtsearchword").val() + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        InvData = jQuery.parseJSON(result.d);

                        if (InvData.length == 0) {
                            lstInvestigation.append($("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            for (i = 0; i < InvData.length; i++) {
                                lstInvestigation.append($("<option></option>").val(InvData[i].ItemID).html(InvData[i].TypeName));

                            }
                        }
                    },
                    error: function (xhr, status) {
                        alert("Error ");

                        window.status = status + "\r\n" + xhr.responseText;
                    }

                });
            });
        });


    </script>

    <script type="text/javascript">

        $(document).ready(function () {
            $("#<%=txtQty.ClientID %>").bind("blur keyup keydown", function () {
                if (($("#<%=txtQty.ClientID %>").val() == "0") || ($("#<%=txtQty.ClientID %>").val() == "") || ($("#<%=txtQty.ClientID %>").val().charAt(0) == "0")) {
                    $("#<%=txtQty.ClientID %>").val(1);

                }
            });
        });
    </script>
    <script type="text/javascript">
        var Ok;
        function ConfirmSave(EntryDt, Name) {
            Ok = confirm('This Service is Already Prescribed By ' + Name + ' Date On ' + EntryDt + '. Do You Want To Prescribe Again ???');
            if (Ok) {
                var btn = document.getElementById("<%=btnAddDirect.ClientID %>");
                btn.click();
            }
            else {
                var btnCancel = document.getElementById("<%=Button2.ClientID %>");
                btnCancel.click();
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
            var options = $('#<% = ListBox1.ClientID %> option');
            $.each(options, function (index, item) {
                values.push(item.innerHTML);
            });

            $('#<% = txtWord.ClientID %>').keyup(function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 38 || key == 40) {
                    var index = $('#<% = ListBox1.ClientID %>').get(0).selectedIndex;
                    if (key == 38) {
                        $('#<% = ListBox1.ClientID %> option:nth-child(' + (index) + ')').attr('selected', 'selected');
                    }
                    else if (key == 40) {
                        $('#<% = ListBox1.ClientID %> option:nth-child(' + (index + 1) + ')').attr('selected', 'selected');
                    }
                $('#<% = txtWord.ClientID %>').val($('#<% = ListBox1.ClientID %> option:nth-child(' + (index + 1) + ')').text());
                }
                else {
                    var filter = $(this).val();
                    if (filter == '') {
                        $('#<% = ListBox1.ClientID %> option:nth-child(1)').attr('selected', 'selected')
                        return;
                    }

                    DoListBoxFilter('#<% = ListBox1.ClientID %>', '#<% = txtWord.ClientID %>', '0', filter, values, key);
                }


            });
            $('#<%=txtSearch.ClientID %>').bind("keyup keydown", function (e) {
                if ($('#<%=txtSearch.ClientID %>').val().length > "0") {
                    $('#<% = txtWord.ClientID %>').val('');
                }
                var key = (e.keyCode ? e.keyCode : e.charCode);
                var filter = $(this).val();
                if (filter == '') {
                    $('#<% = ListBox1.ClientID %> option:nth-child(1)').attr('selected', 'selected')
                    return;
                }
                DoListBoxFilter('#<% = ListBox1.ClientID %>', '#<% = txtSearch.ClientID %>', '1', filter, values, key);
            });


            $('#<% = txtWord.ClientID %>,#<% = ListBox1.ClientID %>').keydown(function (e) {
                var key = (e.keyCode ? e.keyCode : e.charCode);
                if (key == 13) {
                    e.preventDefault();
                    var index = $('#<% = ListBox1.ClientID %>').get(0).selectedIndex;
                    if (index == -1) {
                        $('#<% = lblMsg.ClientID %>').text('Please Select an Investigation');
                        return;
                    }
                    $('#<% = txtWord.ClientID %>').val('');
                    $('#<% = ListBox1.ClientID %> option:nth-child(1)').attr('selected', 'selected')

                }

                else if (key == 38 || key == 40) {
                    var index = $('#<% = ListBox1.ClientID %>').get(0).selectedIndex;
                    if (key == 38) {
                        $('#<% = ListBox1.ClientID %> option:nth-child(' + (index) + ')').attr('selected', 'selected');
                        $('#<% = txtWord.ClientID %>').val($('#<% = ListBox1.ClientID %> option:nth-child(' + (index) + ')').text());
                    }
                    else if (key == 40) {
                        $('#<% = ListBox1.ClientID %> option:nth-child(' + (index + 1) + ')').attr('selected', 'selected');
                        $('#<% = txtWord.ClientID %>').val($('#<% = ListBox1.ClientID %> option:nth-child(' + (index + 2) + ')').text());
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
                $('#<% = ListBox1.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
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
                $('#<% = ListBox1.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
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
                    $('#<% = ListBox1.ClientID %> option:nth-child(' + (i + 1) + ')').attr('selected', 'selected');
                    return;

                    //                    var temp = '<option value="'+keys[i]+'">'+value+'</option>' ;
                    //                    list.append(temp);
                }

            }
        }
    }

    $(textbox).focus();

}
    </script>
    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Services</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

            </div>
            <div class="POuter_Box_Inventory">
                <table style="border-collapse: collapse">
                    <tr>
                        <td align="right" style="font-size: 12px;" class="style4">Category :&nbsp;
                        </td>
                        <td align="left" style="font-size: 12px;" class="style1">
                            <asp:DropDownList ID="ddlCategory" runat="server" Width="268px" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" TabIndex="1" ToolTip="Select Category" />
                        </td>
                        <td align="left" class="style2"></td>
                        <td align="left" class="style3"></td>
                    </tr>
                    <tr>
                        <td align="right" style="font-size: 12px;" class="style4">Search&nbsp;By&nbsp;First 
                        Name :&nbsp;
                        </td>
                        <td align="left" colspan="2" style="font-size: 12px;">
                            <asp:TextBox ID="txtWord" runat="server" AutoCompleteType="Disabled" Width="150px"
                                TabIndex="2" ToolTip="Enter To Select Item"></asp:TextBox>
                            &nbsp;&nbsp; Search By Word :&nbsp;
                            <asp:TextBox ID="txtsearchword" runat="server" AutoCompleteType="Disabled"
                                Width="150px" />
                            &nbsp;
                        </td>
                        <td align="left" style="width: 40%;">&nbsp;CPT Code :
                        <asp:TextBox ID="txtSearch" runat="server" onkeyup="javascript:ValidateCharactercount(10,this);"
                            Width="148px" ToolTip="Enter CPT Code To Search Surgery" TabIndex="5"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" class="style4"></td>
                        <td align="left" colspan="3" style="width: 30%; font-size: 12px;">
                            <asp:ListBox ID="ListBox1" runat="server" Height="144px" Width="524px" ToolTip="Select Item"
                                TabIndex="3"></asp:ListBox>
                            <asp:DropDownList ID="ddlIN" runat="server" Width="86px" CssClass="ItDoseDropdownbox"
                                Visible="False" />
                            <asp:TextBox ID="txtDocCharges" runat="server" Text="0" CssClass="ItDoseTextinputNum"
                                Width="75px" Visible="false" />
                            <cc1:FilteredTextBoxExtender ID="fl1" runat="server" FilterType="Custom,Numbers"
                                ValidChars="." TargetControlID="txtDocCharges" />
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="font-size: 12px;" class="style4">Doctor :&nbsp;
                        </td>
                        <td align="left" colspan="3" style="width: 30%; font-size: 12px;">
                            <asp:DropDownList ID="cmbRefferedBy" runat="server" Width="215px" ToolTip="Select Doctor"
                                TabIndex="4" />
                            &nbsp;&nbsp;&nbsp;Date :&nbsp;
                        <asp:TextBox ID="ucDate" runat="server" ToolTip="Click to Select Date" TabIndex="5"
                            Width="100px"></asp:TextBox>
                            <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="ucDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                            &nbsp;&nbsp;&nbsp;Quantity :&nbsp;<asp:TextBox ID="txtQty" Text="1" runat="server"
                                Width="60px" CssClass="ItDoseTextinputNum" TabIndex="6" ToolTip="Enter Quantity"
                                MaxLength="3" />
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtQty" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <asp:Button ID="btnSelect" runat="server" CssClass="ItDoseButton" Text="Select" OnClick="btnSelect_Click"
                    TabIndex="7" ClientIDMode="Static" ToolTip="Click To Add Item" OnClientClick="return chkValidation(this);" />
            </div>
            <asp:Panel ID="pnlhide" runat="server" Visible="false">
                <div class="POuter_Box_Inventory" style="text-align: center">
                    <div class="Purchaseheader">
                        Service Items
                    </div>
                    <div class="content" style="text-align: center;">
                        <asp:GridView ID="grdItemRate" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False"
                            OnRowDeleting="grdItemRate_RowDeleting">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No." HeaderStyle-Width="25px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Category" HeaderText="Category" HeaderStyle-Width="120px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-HorizontalAlign="Left" />
                                <asp:BoundField DataField="SubCategory" HeaderText="Sub Category" Visible="false"
                                    HeaderStyle-Width="155px" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-HorizontalAlign="Left" />
                                <asp:BoundField DataField="Item" HeaderText="Item" HeaderStyle-Width="165px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Left" />
                                <asp:BoundField DataField="Quantity" HeaderText="Qty." HeaderStyle-Width="34px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="Rate" HeaderText="Rate" HeaderStyle-Width="66px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="TotalAmt" HeaderText="Total Amt." HeaderStyle-Width="66px"
                                    ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle"
                                    ItemStyle-HorizontalAlign="Right" />
                                <asp:BoundField DataField="Date" HeaderText="Date" HeaderStyle-Width="90px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" />
                                <asp:BoundField DataField="Name" HeaderText="Doctor" HeaderStyle-Width="210px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderStyle-CssClass="GridViewHeaderStyle" ItemStyle-HorizontalAlign="Left" />
                                <%--<asp:BoundField DataField="DocCharges" HeaderText="Doc Charges" HeaderStyle-Width="65px"
                                ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle" />--%>
                                <asp:CommandField HeaderStyle-Width="40px" ItemStyle-CssClass="GridViewItemStyle"
                                    HeaderText="Remove" HeaderStyle-CssClass="GridViewHeaderStyle" ButtonType="Image"
                                    DeleteText="Delete Item" ShowDeleteButton="true" DeleteImageUrl="~/Images/Delete.gif"
                                    ItemStyle-HorizontalAlign="Center" />
                                <%--<asp:TemplateField HeaderStyle-Width="15px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Remove" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" ToolTip="Click to Remove Services" runat="server" ImageUrl="~/Images/Delete.gif"
                                        CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>' CommandName="imbRemove" />
                                </ItemTemplate>
                            </asp:TemplateField> --%>
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDoctor_ID" runat="server" Text='<%# Eval("Doctor_ID") %>'></asp:Label>
                                        <asp:Label ID="lblItem" runat="server" Text='<%# Eval("ItemID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <br />
                        <div>
                            <asp:Button AccessKey="r" ID="btnReceipt" OnClick="btnReceipt_Click" runat="server"
                                CssClass="ItDoseButton" Text="Save" CausesValidation="False" TabIndex="8" OnClientClick="return RestrictDoubleEntry(this);"
                                ToolTip="Click To Save Item" />
                        </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:Label ID="lblPatientIDPMH" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblTransactionNoPMH" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblCaseTypeID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblPanel_ID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblReferenceCode" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblDoctor_ID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblCorpseID" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblTransactionID" runat="server" Visible="False"></asp:Label>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtQty"
                Display="None" ErrorMessage="Specify Quantity" SetFocusOnError="True">*</asp:RequiredFieldValidator>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDocCharges"
                Display="None" ErrorMessage="Specify Doctor Charges" SetFocusOnError="True">*</asp:RequiredFieldValidator>
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                ShowSummary="False" />
        </div>
        <asp:Button ID="Button2" runat="server" Text="Button" Style="display: none;" OnClick="Button2_Click" CssClass="ItDoseButton" />
        <asp:Button ID="btnAddDirect" runat="server" Text="Button" OnClick="btnAddDirect_Click"
            Style="display: none;" CssClass="ItDoseButton" />
    </form>
</body>
</html>
