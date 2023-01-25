<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="SubDietType_Master.aspx.cs" Inherits="Design_Kitchen_SubDiteType_Master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript">

        $(document).ready(function () {
            var MaxLength = 100;
            $('#<%=txtDescription.ClientID %>').keypress(function (e) {
                if ($(this).val().length >= MaxLength) {
                    e.preventDefault();
                }
            });
        });
    </script>
    <script type="text/javascript">
        $("[id*=chkselectAll]").live("click", function () {
            var chkHeader = $(this);
            var grid = $(this).closest("table");
            $("input[type=checkbox]", grid).each(function () {
                if (chkHeader.is(":checked")) {
                    $(this).attr("checked", "checked");
                } else {
                    $(this).removeAttr("checked");
                }
            });
        });

        $("[id*=chkselect]").live("click", function () {
            var grid = $(this).closest("table");
            var chkHeader = $("[id*=chkselectAll]", grid);
            if (!$(this).is(":checked")) {
                chkHeader.removeAttr("checked");

            } else {
                if ($("[id*=chkselect]", grid).length == $("[id*=chkselect]:checked", grid).length)
                    chkHeader.attr("checked", "checked");

            }

        });

        function validate(btn) {
            if ($.trim($("#<%=txtTypeName.ClientID%>").val()) == "") {
                modelAlert('Please Enter Sub Diet Type');
                $("#<%=txtTypeName.ClientID%>").focus();
                return false;
            }
            btn.disabled = true;
            btn.value = 'Submitting....';
            if ($("#<%=btnSave.ClientID%>").is(':visible'))
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            else
                __doPostBack('ctl00$ContentPlaceHolder1$btnUpdate', '');
        }

        function disabledBtn(btn) {
            btn.disabled = true;
            btn.value = 'Submitting....';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSavePOP', '');

        }
        function showdivpnl() {
           // $('#pnlItem').show();
        }
    </script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Sub Diet Type Master<br />
            </b>
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" style="display:none;"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Master</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sub Diet Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTypeName" CssClass="requiredField" runat="server" MaxLength="50"></asp:TextBox>
                            <asp:Label
                                ID="lblID" runat="server" Visible="False"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IsActive
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblActive" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="true" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">DeActive</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-5">
                            <asp:Button ID="btnMap" runat="server" CssClass="ItDoseButton" Text="Map Diet Type To Sub Type" OnClientClick="showdivpnl();" OnClick="btnMap_Click" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClientClick="return validate(this)" OnCommand="Button_Command" CommandName="Save" CausesValidation="False" Text="Save" />&nbsp;
                        <asp:Button ID="btnUpdate" runat="server" CssClass="ItDoseButton" OnClientClick="return validate(this)" OnCommand="Button_Command" CommandName="Update" CausesValidation="False" Text="Update" />&nbsp;
                        <asp:Button ID="btnCancel" runat="server" CssClass="ItDoseButton" OnCommand="Button_Command" CommandName="Clear" CausesValidation="False" Text="Cancel" />&nbsp;
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <div class="Purchaseheader">Sub Diet Type Detail</div>
            <div class="Content" style="text-align: center;">
                <asp:Panel ID="pnlgrid" runat="server" ScrollBars="Auto" Height="350px" Visible="false">
                    <asp:GridView ID="grdDetail" runat="server" Width="100%" AutoGenerateColumns="False" CssClass="GridViewStyle" OnSelectedIndexChanged="grdDetail_SelectedIndexChanged">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Name" HeaderText="Sub Diet Type" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="140px" />
                            </asp:BoundField>

                            <asp:BoundField DataField="Description" HeaderText="Description" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                            </asp:BoundField>

                            <asp:TemplateField HeaderText="Active">
                                <ItemTemplate>
                                    <asp:Label ID="lblIsActive" runat="server" Text='<%#Eval("IsActive")%>'></asp:Label>
                                    <div style="display: none;">
                                        <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("SubDietID")+"#"+Eval("Name")+"#"+Eval("Description")+"#"+Eval("IsActive")%>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:CommandField ShowSelectButton="True" SelectText="Edit" ButtonType="Image" SelectImageUrl="~/Images/edit.png" HeaderText="Edit">

                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                            </asp:CommandField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>
        </div>
        <div style="display: none;">
            <asp:Button ID="btnHidden" runat="server" CssClass="ItDoseButton" />
        </div>
        

<%--        <cc1:ModalPopupExtender ID="mpeItems" runat="server"
            CancelControlID="btnCancelpop"
            DropShadow="true"
            TargetControlID="btnHidden"
            BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnlItem"
            PopupDragHandleControlID="dragHandle" />--%>

        <div id="pnlItem"  class="modal fade" runat="server" clientidmode="Static"  >
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: auto;height: auto;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="pnlItem" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Map Diet Type To Sub Type</h4>
				</div>
				<div class="modal-body">
					 				<div class="row" "> 
                                          <asp:DropDownList ID="ddlDietType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDietType_SelectedIndexChanged"></asp:DropDownList>
				</div>
			 	  		<div class="row" ">
                                        <asp:GridView ID="grdsubDtl" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkselectAll" runat="server" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkselect" runat="server" Checked='<%#Util.GetBoolean(Eval("checked")) %>' />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Name" HeaderText="Sub Diet Type" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="220px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Description" HeaderText="Description" ReadOnly="True">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Active">
                                <ItemTemplate>
                                    <asp:Label ID="lblIsActive" runat="server" Text='<%#Eval("IsActive")%>'></asp:Label>
                                    <div style="display: none;">
                                        <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("SubDietID")%>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
				</div>
                    	 
				</div>
				  <div class="modal-footer" style="text-align:center;"> 
                                       <asp:Button ID="btnSavePOP" runat="server" CssClass="ItDoseButton" Text="Save" OnClick="btnSavePOP_Click" OnClientClick="disabledBtn(this)" />
				</div>
			</div>
		</div>
	</div>

    </div>
</asp:Content>
