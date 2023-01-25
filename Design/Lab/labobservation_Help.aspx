<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="labobservation_Help.aspx.cs" Inherits="Design_Lab_labobservation_Help" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        var keys = [];
        var values = [];
        $(document).ready(function () {
            var options = $('#<% = ListBox1.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });

            $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                searchByFirstChar(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
            });
            $('#<%=txtcpt.ClientID %>').keyup(function (e) {
                searchByCPTCode(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
            });
            $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=ListBox1.ClientID%>'), document.getElementById('btnAdd'), values, keys, e)
            });
            $('#ddlobservation').chosen();
        });

        function AddInvestigation(sender, evt) {
            if (evt.keyCode > 0) {
                keyCode = evt.keyCode;
            }
            else if (typeof (evt.charCode) != "undefined") {
                keyCode = evt.charCode;
            }
            if (keyCode == 13) {
                document.getElementById('Button1').click();
            }
        }
       
            function DeleteConfirmation() {
                //if (modelAlert("Are you sure,you want to delete selected records ?") == true)

                //    return true;
                //else
                //    return false;
                return true;
            }

            function validate() {
                if ($.trim($("#<%=txtHelp.ClientID%>").val()) == "") { 
                    modelAlert('Please Enter Help Name');
                    $("#<%=txtHelp.ClientID%>").focus();
                    return false;
                }
            }

            function helpcancel() {
            $("#<%=txtHelp.ClientID%>").val('');
        }

        function editcancel() { 

            $("#<%=txtEdit.ClientID%>").val('');
        }

        function Editvalidate() {
            if ($.trim($("#<%=txtEdit.ClientID%>").val()) == "") { 
                modelAlert('Please Enter Help Name');
                $("#<%=txtEdit.ClientID%>").focus()
                return false;
            }
        }

        function editHelp() {

            if ($("#<%=ListBox1.ClientID%> option:selected").text() == "") {
                modelAlert('Please Select Help');
               // $("#<%=lblMsg.ClientID%>").text('Please Select Help');
                return false;
            } 
            $('#pnlEdit').show();
            $('#<%=txtEdit.ClientID%>').val(($('#ListBox1 option:selected').text()).replace('#','')) 
        }

        function validateMap() {
            if ($("#<%=ddlobservation.ClientID%>").val() == "0") {
                modelAlert('Please Select Observation');
               // $("#<%=lblMsg.ClientID%>").text('Please Select Observation');
                $("#<%=ddlobservation.ClientID%>").focus();
                return false;
            }
            if ($("#<%=ListBox1.ClientID%> option:selected").text() == "") {
                modelAlert('Please Select Help'); 
                return false;
            }
        }
        function OpenHelpPop() {
            $('#pnlSave').show();
        }
    </script>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Investigation Lab Observation Help<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Observation
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div >
                    <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                Observation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlobservation" runat="server" AutoPostBack="True"
                                OnSelectedIndexChanged="ddlobservation_SelectedIndexChanged" ClientIDMode="Static" CssClass="requiredField">
                            </asp:DropDownList>
                            
                        </div>
                         <div class="col-md-1">
                             
                         </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search By Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearch" runat="server" ClientIDMode="Static" onkeydown="AddInvestigation(this, event);">
                            </asp:TextBox>
                        </div>
                        <div style="display: none;" class="col-md-3">
                            <label class="pull-left">
                                CPT Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div style="display: none;" class="col-md-3">
                            <asp:TextBox ID="txtcpt" runat="server" Width="150px" onkeydown="AddInvestigation(this, event);" />
                        </div>
                       
                    </div>
                    <div class="row">
                         <div class="col-md-4">
                            <label class="pull-left">
                                Search By Any Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtInBetweenSearch" runat="server" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"
                                onkeydown="AddInvestigation(this, event);" />
                        </div><div class="col-md-2"></div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Help
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-11">
                            <asp:ListBox ID="ListBox1" runat="server" Height="164px" Width="95%" SelectionMode="Multiple" ClientIDMode="Static"></asp:ListBox>
                            <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" ClientIDMode="Static" Text="Map" CssClass="ItDoseButton" OnClientClick="return validateMap()" />&nbsp;
            <%--<asp:Button ID="BttnAddHelp" runat="server" Text="Add New Help" OnClientClick="return OpenHelpPop();" CssClass="ItDoseButton" />--%>
            <input type="button" id="BttnAddHelp"  value="Add New Help" onclick="return OpenHelpPop();"  class="ItDoseButton" />&nbsp;
            <%--<asp:Button ID="btnEdit" runat="server" Text="Edit Help" OnClientClick="return editHelp()" OnClick="btnEdit_Click" CssClass="ItDoseButton" />--%>
            <input type="button" id="btnEdit" value="Edit Help" onclick="return editHelp()" class="ItDoseButton" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="Purchaseheader">
                All Observation
            </div>
            <Ajax:UpdatePanel ID="update" runat="server">
                <ContentTemplate>
                    <asp:GridView ID="grdObs" runat="server" AutoGenerateColumns="False" ShowHeader="true"
                         OnRowCommand="grdObs_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Observation
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%# Eval("Name")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false">
                                <HeaderTemplate>
                                    Observation
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblid" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                <HeaderTemplate>
                                    Help Name
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <%# Eval("Help")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:CommandField Visible="false" ShowSelectButton="True">
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemStyle CssClass="GridViewItemStyle" />
                            </asp:CommandField>
                            <asp:TemplateField HeaderText="Remove">
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbRemove" runat="server" ImageUrl="~/Images/Delete.gif" OnClientClick="return DeleteConfirmation();"
                                        CausesValidation="false" CommandArgument='<%#Container.DataItemIndex %>' CommandName="imbRemove" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </ContentTemplate>
            </Ajax:UpdatePanel>
        </div>
    </div>
    &nbsp;
    <%--<asp:Panel ID="pnlSave" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;"
        Width="390px">
        <div class="Purchaseheader" id="Div1" runat="server">
            Add Help
        </div>
        <table>
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="lblHelp" runat="server" CssClass="ItDoseLblError" />
                </td>
            </tr>
            <tr>
                <td>Help :&nbsp;
                </td>
                <td style="text-align: right">
                    <asp:TextBox ID="txtHelp" runat="server" MaxLength="50"
                        Width="188px"></asp:TextBox>
                    <asp:Label ID="Label10" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>
            </tr>
        </table>

        <div class="filterOpDiv" style="text-align: center">

            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                OnClick="btnSave_Click" OnClientClick="return validate()" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />
        </div>
    </asp:Panel>--%>
        <div id="pnlSave"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 272px;height: 150px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="pnlSave" aria-hidden="true">&times;</button>
					<h4 class="modal-title"> Add Help</h4>
				</div>
				<div class="modal-body">
					 				<div class="row">
                    <div class="col-md-5">
                    
                         <label class="pull-left">Help </label>
                            <b class="pull-right">:</b>    
                    </div>
                    <div class="col-md-8">
                           <asp:TextBox ID="txtHelp" runat="server" MaxLength="50" CssClass="requiredField"
                        Width="188px"></asp:TextBox>
                    </div>
				</div>
			 	  
				</div>
				  <div class="modal-footer">
						 <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                OnClick="btnSave_Click" OnClientClick="return validate()" />
						 <button type="button"  data-dismiss="pnlSave" aria-hidden="true" >Close</button>
				</div>
			</div>
		</div>
	</div>
    <%--<asp:Panel ID="pnlEdit" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;"
        Width="390px">
        <div class="Purchaseheader" id="Div3" runat="server">
            Edit Help
        </div>
        <table>
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="lblEditHelp" runat="server" CssClass="ItDoseLblError" />
                </td>
            </tr>
            <tr>
                <td>Help :&nbsp;
                </td>
                <td style="text-align: right">
                    <asp:TextBox ID="txtEdit" runat="server" CssClass="ItDoseTextinputText" MaxLength="50"
                        Width="188px"></asp:TextBox>
                    <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>
            </tr>
        </table>



        <div class="filterOpDiv" style="text-align: center">
            &nbsp;&nbsp;
            <asp:Button ID="btnEditUpdate" runat="server" Text="Update" CssClass="ItDoseButton"
                OnClick="btnEditUpdate_Click" OnClientClick="return Editvalidate()" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnEditCancel" runat="server" Text="Cancel" CausesValidation="false"
                CssClass="ItDoseButton" />
        </div>
    </asp:Panel>--%>
    <div id="pnlEdit"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 272px;height: 150px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="pnlEdit" aria-hidden="true">&times;</button>
					<h4 class="modal-title"> Edit Help</h4>
				</div>
				<div class="modal-body">
					 				<div class="row">
                    <div class="col-md-5">
                    
                         <label class="pull-left">Help </label>
                            <b class="pull-right">:</b>    
                    </div>
                    <div class="col-md-8">
                          <asp:TextBox ID="txtEdit" runat="server" CssClass="ItDoseTextinputText requiredField" MaxLength="50"
                        Width="188px"></asp:TextBox>
                    </div>
				</div>
			 	  
				</div>
				  <div class="modal-footer">
						 <asp:Button ID="btnEditUpdate" runat="server" Text="Update" CssClass="ItDoseButton"
                OnClick="btnEditUpdate_Click" OnClientClick="return Editvalidate()" />
						 <button type="button"  data-dismiss="pnlEdit" aria-hidden="true" >Close</button>
				</div>
			</div>
		</div>
	</div>
<%--    <cc1:ModalPopupExtender ID="mdpSave" runat="server" CancelControlID="btnCancel" DropShadow="true"
        TargetControlID="btnHidden1" BackgroundCssClass="filterPupupBackground" PopupControlID="pnlSave"
        PopupDragHandleControlID="pnlSave" OnCancelScript="helpcancel()">
    </cc1:ModalPopupExtender>--%>
 <%--   <cc1:ModalPopupExtender ID="mdpEditHelp" runat="server" CancelControlID="btnEditCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlEdit" PopupDragHandleControlID="pnlEdit" OnCancelScript="editcancel()">
    </cc1:ModalPopupExtender>--%>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton"></asp:Button>
        <asp:Button ID="btnHidden1" runat="server" Text="Button" Style="display: none;" CssClass="ItDoseButton"></asp:Button>
    </div>
</asp:Content>
