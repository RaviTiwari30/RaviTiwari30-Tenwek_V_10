<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="PanelDocumentMaster.aspx.cs" Inherits="Design_EDP_ActivateItem" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=chkSelect.ClientID %>").click(function () {
                $("#<%= chkDocuments.ClientID %> input:checkbox").attr('checked', this.checked);
            });

            $("#<%=chkDocuments.ClientID %> input:checkbox").click(function () {
                if ($("#<%= chkSelect.ClientID %>").attr('checked') == true && this.checked == false)
                    $("#<%= chkSelect.ClientID %>").attr('checked', false);

                if (this.checked == true)
                    CheckSelectAll();
            });

            function CheckSelectAll() {
                var flag = true;
                $("#<%=chkDocuments.ClientID %> input:checkbox").each(function () {
                    if (this.checked == false)
                        flag = false;
                });
                $("#<%= chkSelect.ClientID %>").attr('checked', flag);
            }

        });
        function Doc() {
            if ($.trim($("#<%=txtNewDoc.ClientID%>").val()) == "") {
            $("#<%=lblDocError.ClientID%>").text('Please Enter Document Name');
            $("#<%=txtNewDoc.ClientID%>").focus();
            return false;
        }
        document.getElementById('<%=btnSaveDoc.ClientID%>').disabled = true;
        document.getElementById('<%=btnSaveDoc.ClientID%>').value = 'Submitting...';
        __doPostBack('ctl00$ContentPlaceHolder1$btnSaveDoc', '');
    }

    function DocClear() {
        $("#<%=lblDocError.ClientID%>").text('');
            $("#<%=txtNewDoc.ClientID%>").val('');
        }
    </script>



    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Panel Document Master<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Panel Detail&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" OnSelectedIndexChanged="ddlPanel_SelectedIndexChanged" AutoPostBack="True">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnCreateNew" runat="server" CssClass="ItDoseButton" Text="Create New Document" />
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Document Details
             <asp:CheckBox ID="chkSelect" runat="server" AutoPostBack="False" OnCheckedChanged="chkSelect_CheckedChanged" />
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <asp:CheckBoxList ID="chkDocuments" runat="server" RepeatColumns="4" RepeatDirection="Horizontal" Width="956px">
                            </asp:CheckBoxList>&nbsp;
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div  style="text-align: center">
                <asp:Button ID="btnPanel" runat="server" CssClass="ItDoseButton" Text="Apply to These Panels Also" />&nbsp;
        <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" Width="60px" Text="Save" OnClick="btnSave_Click" />
            </div>
        </div>
    </div>
    <asp:Panel ID="pnlDoc" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="500px" Height="94px">
        <div id="dragHandle" runat="server" class="Purchaseheader">
            Create&nbsp; New Document
        </div>

        <table>
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="lblDocError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">Document :&nbsp;
                </td>
                <td>
                    <asp:TextBox ID="txtNewDoc" runat="server" MaxLength="50" Width="323px"></asp:TextBox>
                    <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>

            </tr>
        </table>



        <div class="filterOpDiv">
            <asp:Button ID="btnSaveDoc" runat="server" CssClass="ItDoseButton"
                Text="Save" OnClick="btnSaveDoc_Click" OnClientClick="return Doc()" />
            &nbsp;<asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton"
                Text="Cancel" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpDoc" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlDoc" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnCreateNew" OnCancelScript="DocClear()">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlSponsor" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="530px">
        <div id="Div1" runat="server" class="Purchaseheader">
            Select Panel To Apply Selected Documents :
        </div>
        <div class="content">
            <table cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td style="width: 5%" valign="top">Panel :</td>
                    <td style="width: 95%">
                        <div style="overflow: scroll; height: 200px; width: 432px; text-align: left;" class="border">
                            <asp:CheckBoxList ID="chkPanel2" runat="server" RepeatColumns="1">
                            </asp:CheckBoxList>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="filterOpDiv">
            <asp:Button ID="btnSavePanel" runat="server" CssClass="ItDoseButton"
                Text="Save" OnClick="btnSavePanel_Click" />
            <asp:Button ID="btnCancelPanel" runat="server" CssClass="ItDoseButton"
                Text="Cancel" />
        </div>
    </asp:Panel>
    <cc1:ModalPopupExtender ID="mpePanel" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnCancelPanel" DropShadow="true" PopupControlID="pnlSponsor" PopupDragHandleControlID="dragHandle"
        TargetControlID="btnPanel">
    </cc1:ModalPopupExtender>
    <div style="display: none">
        <asp:Button ID="Button1" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>


</asp:Content>
