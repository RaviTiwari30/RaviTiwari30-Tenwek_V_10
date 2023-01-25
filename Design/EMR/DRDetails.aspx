<%@ Page Language="C#" ValidateRequest="false" EnableEventValidation="false" AutoEventWireup="true"
    MaintainScrollPositionOnPostback="true" CodeFile="DRDetails.aspx.cs" Inherits="Design_EMR_DRDetails" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>IPD Patient Billing</title>

    
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=txtTempHeader.ClientID %>").val('').attr('disabled', 'disabled');
            $('#<%=rdbTemplate.ClientID %> input').change(function () {
                var radios = $("#<%=rdbTemplate.ClientID%> input[type=radio]:checked").val();
                if (radios == "New" || radios == "Update") {
                    $("#<%=lbltemplateheader.ClientID %>").val('').removeAttr('disabled');
                    $("#<%=txtTempHeader.ClientID %>").val('').removeAttr('disabled');
                    if ($("#<%=ddlTemplates.ClientID %>").val() != "") {
                        $.trim($("#<%=txtTempHeader.ClientID %>").val($("#<%=ddlTemplates.ClientID %> option:selected").text()));
                    }
                }
                else {
                    $("#<%=lbltemplateheader.ClientID %>").val('').attr('disabled', 'disabled');
                    $("#<%=txtTempHeader.ClientID %>").val('').attr('disabled', 'disabled');
                }
            });
            ChangeColourdropdown();
            $('#ddlHeader').chosen();
           $('#ddlDepartment').chosen();
        });
        function ShowHide() {
            var radios = $("#<%=rdbTemplate.ClientID%> input[type=radio]:checked").val();
            if (radios == "New" || radios == "Update") {
                $("#<%=lbltemplateheader.ClientID %>").val('').removeAttr('disabled');
                $("#<%=txtTempHeader.ClientID %>").val('').removeAttr('disabled');
                if ($("#<%=ddlTemplates.ClientID %>").val() != "") {
                    $.trim($("#<%=txtTempHeader.ClientID %>").val($("#<%=ddlTemplates.ClientID %> option:selected").text()));
                }
            }
            else {
                $("#<%=lbltemplateheader.ClientID %>").val('').attr('disabled', 'disabled');
                $("#<%=txtTempHeader.ClientID %>").val('').attr('disabled', 'disabled');
            }
        }
        function Note() {
            var Status = confirm(" You Want To Delete this Template");
            if (Status == false)
                return false;
            else { return true; }
        }


        var ChangeColourdropdown = function () {

            var ID = $('#hdntransactionId').val();
            serverCall('Services/EMR.asmx/GetDischargeType', { Id: ID }, function (response) {

                var responseData = JSON.parse(response);
                var Maindt = responseData.dtmandatory;
                var dt1 = responseData.dtadded;
                var select = $('#ddlHeader')[0];

                for (var i = 1; i < select.length; i++) {
                    var option = select.options[i];
                    for (var j = 0; j < Maindt.length; j++) {
                        if (option.text == Maindt[j].HeaderName && Maindt[j].mandatoryType == '1') {
                            //$(option.value).attr('style', 'background-color:red;');

                            $("#ddlHeader option[value=" + option.value + "]").css("background-color", "yellow");
                            //$(option.value).css("background-color", "red");
                           
                        }
                        for (var k = 0; k < dt1.length; k++) {
                            if (Maindt[j].HeaderName == dt1[k].HeaderName) {
                                if (option.text == dt1[k].HeaderName) {

                                    $('#ddlHeader').chosen('destroy'); 
                                    $("#ddlHeader option[value=" + option.value + "]").css("background-color", "lightgreen");
                                    

                                }

                            }

                        }

                    }

                }

            });
        }

    </script>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hdntransactionId" runat="server" />
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="ScriptManager" runat="Server" />
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Discharge Report
                </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Discharge Details Entries&nbsp;
                </div>
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Discharge Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lbldischargeType" runat="server" Style="color: black;" CssClass="ItDoseLblError" />

                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                            </label>

                        </div>
                        <div class="col-md-5">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: lightgreen;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Already Added</b> &nbsp;

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>

                        </div>
                        <div class="col-md-5">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellow;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Mandatory Header</b> &nbsp;

                        </div>

                    </div>
                    <div class="row">

                        <div class="col-md-3">
                            <label class="pull-left">
                                User
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlEmployee" runat="server" AutoPostBack="True" TabIndex="5">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Is Shared                           
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="chkIsSahred" runat="server" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server" TabIndex="5" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged" AutoPostBack="true" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-3">
                            <label class="pull-left">
                                Header
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlHeader" runat="server" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlHeader_SelectedIndexChanged" TabIndex="5" ClientIDMode="Static">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Templates
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlTemplates" runat="server" TabIndex="6" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlTemplates_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                           <asp:Button ID="btnDelete" runat="server" Text="Delete Template" CssClass="ItDoseButton" Visible="false" OnClick="btnDelete_Click" OnClientClick="return Note()" />
                        </div>
                    </div>
                </div>
            </div>
            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                <tr>
                    <td style="width: 15%; text-align: right">
                        <%--Details :--%>&nbsp;
                    </td>
                    <td style="width: 50%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <%--<td align="right" colspan="2">--%>
                    <td style="height: 12px; vertical-align: middle; text-align: left" colspan="2">

                        <CKEditor:CKEditorControl ID="txtDetail" BasePath="~/ckeditor" runat="server" EnterMode="BR"></CKEditor:CKEditorControl>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: right"></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 80%">
                <tr>
                    <td style="width: 13%; text-align: left">
                        <asp:Button ID="btnAddItem" runat="server" CausesValidation="False" CssClass="ItDoseButton"
                            Text="Add Details" OnClick="btnAddItem_Click" TabIndex="8" />
                    </td>
                    <td style="text-align: left; width: 45%" colspan="3">
                        <asp:RadioButtonList ID="rdbTemplate" runat="server" CssClass="ItDoseRadiobuttonlist" RepeatDirection="Horizontal">
                            <asp:ListItem Value="Update"> Update Template</asp:ListItem>
                            <asp:ListItem Value="New">New Template</asp:ListItem>
                            <asp:ListItem Value="Nothing" Selected="True">Nothing</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td colspan="2">
                        <asp:Label runat="server" ID="lbltemplateheader" Text="Temp. Name :"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtTempHeader" runat="server" Width="191px" TabIndex="10"></asp:TextBox></td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Discharge Details Entries&nbsp;
            </div>
            <div style="text-align: center;">
                <asp:GridView ID="grdHeader" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    PageSize="5" Width="100%" OnRowCommand="grdHeader_RowCommand" OnRowDataBound="grdHeader_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Header Added">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="500px" HorizontalAlign="Left" />
                            <ItemTemplate>
                                <asp:Label ID="lblheader" runat="server" Text='<%#Eval("HeaderName")%>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                &nbsp;<asp:ImageButton ID="imbModify" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                    CommandName="AEdit" ImageUrl="~/Images/edit.png" ToolTip="Modify Item" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Delete">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            <ItemTemplate>
                                &nbsp;<asp:ImageButton ID="imbDelete" runat="server" CausesValidation="false" CommandArgument='<%# Container.DataItemIndex %>'
                                    CommandName="ADelete" ImageUrl="~/Images/Delete.gif" ToolTip="Delete Item" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="lblReportTypeHeaderID" runat="server" Text='<%# Eval("Header_ID") %>'
                                    Visible="False"></asp:Label>
                                <asp:Label ID="lblApproved" runat="server" Text='<%# Eval("Approved") %>'
                                    Visible="False"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width: 100%">
                <tr style="text-align: center">
                    <td style="width: 100px">
                        <asp:Button ID="btnSave" runat="server" CausesValidation="False" CssClass="ItDoseButton"
                            Text="Save" OnClick="btnSave_Click" TabIndex="11" Visible="False" />
                    </td>
                    <td style="width: 100px; display: none">
                        <asp:RadioButtonList ID="rbtnFormat" runat="server" RepeatDirection="Horizontal" Width="145px">
                            <asp:ListItem Selected="True">PDF</asp:ListItem>
                            <asp:ListItem>Word</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                    <td style="text-align: center">
                        <asp:Button ID="btnPrint" runat="server" CausesValidation="False" CssClass="ItDoseButton"
                            OnClick="btnPrint_Click" Text="Print" />&nbsp;&nbsp;&nbsp;&nbsp;
                               <asp:Button ID="btnApprove" runat="server" CausesValidation="False" CssClass="ItDoseButton" Visible="false"
                                   Text="Approve" OnClick="btnApprove_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:DropDownList ID="ddlApproved" Visible="false" runat="server" Width="200px"></asp:DropDownList>

                    </td>
                </tr>
            </table>
        </div>
        </div>
        <asp:Panel ID="Panel1" runat="server" CssClass="pnlVendorItemsFilter" BackColor="#F3F7FA"
            Width="869px" Style="display: none">
            <%--  <div class="Purchaseheader">
                &nbsp;</div>--%>
        &nbsp;<div class="Outer_Box_Inventory" id="DIV1" onclick="return DIV1_onclick()"
            style="width: 606px">
            <div class="Purchaseheader" style="text-align: center">
                Available Items&nbsp;
            </div>
            <div class="content">
                <table border="0" cellpadding="0" cellspacing="0" class="border1" style="width: 590px">
                    <tbody>
                        <tr>
                            <td style="height: 23px; text-align: left; vertical-align: middle">
                                <asp:CheckBoxList ID="chk" runat="server" DataTextField="itemname" RepeatColumns="1"
                                    Width="581px" />
                            </td>
                        </tr>
                        <tr>
                            <td class="headingtext2" style="text-align: center; height: 32px; vertical-align: middle">
                                <br />
                                &nbsp;<asp:Button ID="btn_Cancel" CssClass="ItDoseButton" runat="server" Text="CLOSE"
                                    OnClick="btn_Cancel_Click" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        </asp:Panel>
        <div style="display: none">
            <cc1:ModalPopupExtender ID="ModalPopupExtender1" DropShadow="true" runat="server"
                BackgroundCssClass="filterPupupBackground" TargetControlID="btn1" X="75" Y="50"
                PopupControlID="panel1">
            </cc1:ModalPopupExtender>
            <asp:Button ID="btn1" runat="server" CssClass="ItDoseButton" />
        </div>
    </form>
</body>
</html>
