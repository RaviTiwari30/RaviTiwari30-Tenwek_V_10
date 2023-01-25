<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="FileManager.aspx.cs" Inherits="Design_EDP_FileManager" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript">
        var popup
        function showDirectory() {
            var w = 350;
            var h = 455;
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            popup = window.open("browseDirectory.aspx?Frame=Menu", "view", "width=" + w + ",height=" + h + ",top=" + top + ",left=" + left + "  ");
            popup.focus();
            return false
        }

        $(document).ready(function () {
            $('#ddlMenu').chosen();
            var MaxLength = 100;
           
            $('#<%=txtFDesc.ClientID%>').bind("keypress", function (e) {
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

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
        
    </script>
    
    <div id="Pbody_box_inventory">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>File Management</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <table style="width:100%;border-collapse:collapse">
                <tr>
                    <td style="text-align:right">
                         Menu Name :&nbsp;
                    </td>
                    <td style="text-align:left;width:290px;">
                         <asp:DropDownList ID="ddlMenu" runat="server"  Width="250px" ClientIDMode="Static" />
                    </td>
                    <td>
                     <asp:Button ID="btnFile" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnFile_Click" />
                    </td>
                    <td>
                        <%--<asp:Button ID="btnmnu" runat="server" CssClass="ItDoseButton" Text="New & Edit Menu" ClientIDMode="Static"  />--%>
                        <input type="button" value="New & Edit Menu" id="btnmnu" />
                    </td>
                    <td>
                        <asp:Button ID="btnNewFile" runat="server" CssClass="ItDoseButton" Text="New Files" />
                    </td>
                    <td style="width:30%">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                </tr>
            </table>
            <div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Files Detail
            </div>
            <div >
                <asp:GridView ID="grdFile" runat="server" Width="100%" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowCommand="grdFile_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="FileName" HeaderStyle-Width="200px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Eval("DispName") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Description" HeaderStyle-Width="350px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Eval("Description")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Menu" HeaderStyle-Width="150px" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle">
                            <ItemTemplate>
                                <%#Eval("MenuName")%>
                                <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID") %>' Visible="False"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:ButtonField CommandName="AEdit" HeaderText="Edit" Text="Edit" ItemStyle-CssClass="GridViewItemStyle"
                            HeaderStyle-CssClass="GridViewHeaderStyle" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button"  CssClass="ItDoseButton"/>
    </div>
    <asp:Panel ID="pnlUpdate" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;">
        <div class="Purchaseheader" id="dragUpdate" runat="server">
            Update File Details</div>
        <div class="content">
            <table style="width:100%;border-collapse:collapse">
                <tr>
                    <td style="text-align:right;width:20%">
                         FileName :&nbsp;
                    </td>
                    <td style="text-align:left">
                        <asp:Label ID="lblFileName" runat="server" Font-Bold="true" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;<asp:Label
                ID="lblFileId" runat="server" Visible="False"></asp:Label>
                    </td>
                </tr>
                 <tr>
                    <td style="text-align:right;width:20%;vertical-align:top">
                      Description :&nbsp;   </td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtDesc" runat="server"  TextMode="MultiLine"
                Width="265px"></asp:TextBox>
                    </td>
                     </tr>
                <tr>
                    <td style="text-align:right;width:20%">
                      MenuName :&nbsp; </td>
                    <td style="text-align:left">
 <asp:DropDownList ID="ddlMenu1" runat="server"  Width="270px" ClientIDMode="Static">
            </asp:DropDownList>
                    </td>
                     </tr>
                 <tr>
                    <td style="text-align:right;width:20%">
                        &nbsp;
                       </td>
                    <td style="text-align:left">
<asp:RadioButton ID="rdbActive" runat="server" Text="Active" GroupName="a" Checked="True" />
            <asp:RadioButton ID="rdbNonActive" runat="Server" Text="DeActive" GroupName="a" />
                    </td>
                     </tr>
            </table>
            
            
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                Text="Save" ValidationGroup="Save"  />&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancel" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Cancel"  />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpeCreateGroup" runat="server" CancelControlID="btnCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUpdate" PopupDragHandleControlID="dragHandle" >
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlmnu" runat="server" CssClass="pnlFilter" Style="display: none;" Width="350px">
        <div class="Purchaseheader" id="Div1" runat="server">
            New Menu</div>
        <div>
            <table >
                <tr>
                    <td style="text-align:right;vertical-align:central;" valign="middle">
Menu :&nbsp;
                    </td>
                    <td style="text-align:left">
                        <asp:TextBox ID="lblmenuid" runat="server" ClientIDMode="Static" style="display:none"></asp:TextBox>
                        <asp:TextBox ID="txtNMenu" runat="server"  MaxLength="20" ToolTip="Enter Menu" ClientIDMode="Static" AutoCompleteType="Disabled" ></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtNMenu"
                ErrorMessage="Specify Menu" SetFocusOnError="True" ValidationGroup="Menu">*</asp:RequiredFieldValidator><br />
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                ShowSummary="False" ValidationGroup="Menu" />
                    </td>
                </tr>
                <tr><td style="text-align:right"> Browse Image :&nbsp;</td><td style="text-align:left"><asp:FileUpload ID="fileuploadmenu" runat="server" Width="200px"  /></td></tr>
            </table>
           
            
        </div>
        <div class="filterOpDiv" style="text-align:center">
            <asp:Button ID="btnSaveMnu" runat="server" CssClass="ItDoseButton" OnClick="btnSaveMnu_Click"
                Text="Save" ValidationGroup="Menu"  />&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancelMnu" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Cancel"  />
           <%-- <asp:Button ID="btnHidden" runat="server" style="display:none" />--%>
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" CancelControlID="btnCancelMnu" ClientIDMode="Static"
        PopupControlID="pnlmnu" BackgroundCssClass="filterPupupBackground" TargetControlID="btnHidden" >
    </cc1:ModalPopupExtender>
      <%--<cc1:ModalPopupExtender ID="mpePatientResult" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnCancelMnu" PopupControlID="pnlmnu" TargetControlID="btnHidden" ClientIDMode="Static"
     </cc1:ModalPopupExtender>--%>
    <asp:Panel ID="pnlNfile" runat="server" CssClass="pnlFileFilter" Style="width: 380px;
        display: none">
        <div class="Purchaseheader" id="Div2" runat="server">
            File Detail  </div> <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="text-align:right" >
                        Menu :&nbsp;
                    </td>
                    <td style="text-align:left">
                        <asp:DropDownList ID="ddlNfile" runat="server" Width="245px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right">
                        File&nbsp;Name :&nbsp;
                    </td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtdispName" runat="server" CssClass="ItDoseTextinputText" Width="240px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                     <td style="text-align:right">
                        URL :&nbsp;
                    </td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtURL" runat="server" Font-Bold="true" CssClass="ItDoseTextinputText"  ClientIDMode="Static"
                            Width="240px"></asp:TextBox>
                        <a href="javascript:void(0);" onclick="showDirectory();">
                            <img src="../../Images/view.GIF" style="border: none;" /></a>
                    </td>
                </tr>
                <tr>
                     <td style="text-align:right;vertical-align:top" >
                        Description :&nbsp;
                    </td>
                    <td style="text-align:left">
                        <asp:TextBox ID="txtFDesc" runat="server" CssClass="ItDoseTextinputText" Width="240px"
                            TextMode="MultiLine"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtURL"
                            ErrorMessage="Specify URL" Display="None" SetFocusOnError="True" ValidationGroup="NFile">*</asp:RequiredFieldValidator><br />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtdispName"
                            ErrorMessage="Specify File Name" Display="None" SetFocusOnError="True" ValidationGroup="NFile">*</asp:RequiredFieldValidator><br />
                        <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="True"
                            ShowSummary="False" ValidationGroup="NFile" />
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        URL&nbsp; : /Design/Purchase/FileName.aspx
                    </td>
                </tr>
            </table>
       
        <div class="filterOpDiv">
            <asp:Button ID="btnFileSave" runat="server" CssClass="ItDoseButton" OnClick="btnFileSave_Click"
                Text="Save" ValidationGroup="NFile" Width="65px" />&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnFileCancel" runat="server" CausesValidation="false" CssClass="ItDoseButton"
                Text="Cancel" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" CancelControlID="btnFileCancel"
        DropShadow="true" TargetControlID="btnNewFile" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlNfile" PopupDragHandleControlID="dragHandle">
    </cc1:ModalPopupExtender>

    <script type="text/javascript">
        $('#btnmnu').click(function(){
            if ($('#ddlMenu').val() == 0) {
                $('#lblmenuid').val('');
                $('#txtNMenu').val('');
            }
            else {
                $('#lblmenuid').val($('#ddlMenu').val());
                $('#txtNMenu').val($('#ddlMenu option:selected').text());
                
            }
            $find("ModalPopupExtender1").show();
        });
    </script>
</asp:Content>
