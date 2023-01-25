<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Component_Master.aspx.cs" Inherits="Design_Kitchen_Componenet_Master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            var MaxLength = 100;
            $('#<%=txtDescription.ClientID %>').keypress(function (e) {
                if ($(this).val().length >= MaxLength) {
                    e.preventDefault();
                }
            });
        });

        function RestrictDoubleEntry(btn) {
            btn.disabled = true;
            btn.value = 'Submitting....';

        }
        function validatespace() {
            var Name = $('#<%=txtTypeName.ClientID %>').val();
            var Desc = $('#<%=txtDescription.ClientID %>').val();
            if (Name.charAt(0) == ' ' || Name.charAt(0) == '.' || Name.charAt(0) == ',') {
                $('#<%=txtTypeName.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                modelAlert('First Character Cannot Be Space/Dot');
                Name.replace(Name.charAt(0), "");
                return false;
            }
            if (Desc.charAt(0) == ' ' || Desc.charAt(0) == '.' || Desc.charAt(0) == ',') {
                $('#<%=txtDescription.ClientID %>').val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                modelAlert('First Character Cannot Be Space/Dot');
                Desc.replace(Desc.charAt(0), "");
                return false;
            }
            else {
                return true;
            }

        }

        function validate(btn) {
            if ($.trim($('#<%=txtTypeName.ClientID %>').val()) == "") {
                $('#<%=lblmsg.ClientID %>').text('Please Enter Component Name');
                modelAlert('Please Enter Component Name');
                $('#<%=txtTypeName.ClientID %>').focus();
                return false;
            }
            if ($('#<%=ddlType.ClientID %>').val() == "0") {
                $('#<%=lblmsg.ClientID %>').text('Please Select Type');
                modelAlert('Please Select Type');
                $('#<%=ddlType.ClientID %>').focus();
                return false;
            }
            if ($('#<%=ddlUnit.ClientID %>').val() == "0") {
                $('#<%=lblmsg.ClientID %>').text('Please Select Unit');
                modelAlert('Please Select Unit'); 
                $('#<%=ddlUnit.ClientID %>').focus();
                return false;
            }
            btn.disabled = true;
            btn.value = 'Submitting....';
            if ($("#<%=btnSave.ClientID%>").is(':visible'))
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            else
                __doPostBack('ctl00$ContentPlaceHolder1$btnUpdate', '');
        }
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Component Master</b><br />

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
                                Component Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTypeName" CssClass="requiredField" runat="server" MaxLength="100" onkeyup="validatespace();"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbeType" runat="server" FilterType="Custom,LowercaseLetters,UppercaseLetters,Numbers" ValidChars="., &?/" TargetControlID="txtTypeName"></cc1:FilteredTextBoxExtender>
                            <asp:Label ID="lblID" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="lblItemID" runat="server" Visible="False"></asp:Label>
                        </div>                       
                        <div class="col-md-3">
                            <label class="pull-left">
                                Description
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDescription" runat="server" onkeyup="validatespace();" TextMode="MultiLine"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Custom,LowercaseLetters,UppercaseLetters,Numbers" ValidChars="., &?/" TargetControlID="txtDescription"></cc1:FilteredTextBoxExtender>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList CssClass="requiredField" ID="ddlType" runat="server">
                                <asp:ListItem Value="0">Select</asp:ListItem>
                                <asp:ListItem Value="1">Solid</asp:ListItem>
                                <asp:ListItem Value="2">Liquid</asp:ListItem>
                                <asp:ListItem Value="3">Powder</asp:ListItem>
                                <asp:ListItem Value="4">Paste</asp:ListItem>
                                <asp:ListItem Value="5">Semi-Solid</asp:ListItem>
                                <asp:ListItem Value="6">Grains</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">  
                        <div class="col-md-3">
                            <label class="pull-left">
                                Calories&nbsp;(KCal)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCalories" runat="server" MaxLength="10"></asp:TextBox>
                        </div>                                            
                        <div class="col-md-3">
                            <label class="pull-left">
                                SaturatedFat (g)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSaturatedFat" runat="server" MaxLength="10"></asp:TextBox>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                TFat (g)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtTFat" runat="server" MaxLength="10"></asp:TextBox>
                        </div>                                               
                    </div>
                    <div class="row">
                         <div class="col-md-3">
                            <label class="pull-left">
                                Iron &nbsp;(mg)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIron" runat="server" MaxLength="10"></asp:TextBox>                           
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Calcium &nbsp;(mg)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCalcium" runat="server" MaxLength="10"></asp:TextBox>
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Protein (g)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtProtein" runat="server" MaxLength="10"></asp:TextBox>
                        </div> 
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Zinc&nbsp;(mg)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtZinc" runat="server" MaxLength="10"></asp:TextBox>                           
                        </div>
                         <div class="col-md-3">
                            <label class="pull-left">
                                Sodium (g)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSodium" runat="server" MaxLength="10"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Potassium&nbsp;(g)
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPotassium" runat="server" MaxLength="10"></asp:TextBox>                           
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Unit
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlUnit"  runat="server">
                                <asp:ListItem Value="0">Select</asp:ListItem>
                                <asp:ListItem Value="1">Soup Laddle</asp:ListItem>
                                <asp:ListItem Value="2">Piece</asp:ListItem>
                                <asp:ListItem Value="3">Slice</asp:ListItem>
                                <asp:ListItem Value="4">Roll</asp:ListItem>
                                <asp:ListItem Value="5">1Tbs</asp:ListItem>
                                <asp:ListItem Value="6">Whole</asp:ListItem>
                                <asp:ListItem Value="7">Teaspoon</asp:ListItem>
                                <asp:ListItem Value="8">Tablespoon</asp:ListItem>
                                <asp:ListItem Value="9">Triangle</asp:ListItem>
                                <asp:ListItem Value="10">Cup</asp:ListItem>
                                <asp:ListItem Value="11">Pallet</asp:ListItem>
                                <asp:ListItem Value="12">Finger</asp:ListItem>
                                <asp:ListItem Value="13">Bowl</asp:ListItem>
                                <asp:ListItem Value="14">Ball</asp:ListItem>
                                <asp:ListItem Value="15">Stew Laddle</asp:ListItem>
                                <asp:ListItem Value="16">Cup 200 ml</asp:ListItem>
                                <asp:ListItem Value="17">Plate</asp:ListItem>
                                <asp:ListItem Value="18">Set</asp:ListItem>
                            </asp:DropDownList>
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
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSave" runat="server" CausesValidation="False" CssClass="ItDoseButton" OnClick="btnSave_Click"
                Text="Save" OnClientClick="return validate(this)" />&nbsp;&nbsp;<asp:Button ID="btnUpdate" runat="server" CausesValidation="False"
                    OnClick="btnUpdate_Click" CssClass="ItDoseButton" Text="Update" OnClientClick="return validate(this)" />&nbsp;&nbsp;<asp:Button ID="btnCancel" runat="server"
                        CausesValidation="False" OnClick="btnCancel_Click" CssClass="ItDoseButton" Text="Cancel" />
        </div>
        <asp:Panel ID="pnlHide" Visible="false" runat="server">

            <div class="POuter_Box_Inventory" style="text-align: center;">

                <div class="Purchaseheader">Diet Type Detail</div>
                <div class="Content" style="text-align: center;">
                    <asp:Panel ID="pnlgrid" runat="server" ScrollBars="Auto" Height="350px">
                        <asp:GridView ID="grdDetail" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnSelectedIndexChanged="grdDetail_SelectedIndexChanged">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="2%" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Component Name" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20%" />
                                </asp:BoundField>

                                <asp:BoundField DataField="Description" HeaderText="Description" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="30%" />
                                </asp:BoundField>

                                <asp:BoundField DataField="Type" HeaderText="Type" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Unit" HeaderText="Unit" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Calories" HeaderText="Calories(Kcal)" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>                              
                                <asp:BoundField DataField="SaturatedFat" HeaderText="Saturated Fat(g)" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="T_Fat" HeaderText="TFat(g)" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="Iron" HeaderText="Iron(mg)" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Calcium" HeaderText="Calcium(mg)" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Protein" HeaderText="Protein(g)" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Zinc" HeaderText="Zinc(mg)" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Sodium" HeaderText="Sodium(g)" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="Potassium" HeaderText="Potassium(g)" ReadOnly="True">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Active">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIsActive" runat="server" Text='<%#Eval("IsActive")%>'></asp:Label>
                                        <div style="display: none;">
                                            <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("ComponentID")+"#"+Eval("Name")+"#"+Eval("Description")+"#"+Eval("IsActive")+"#"+Eval("Type")+"#"+Eval("Unit")+"#"+Eval("Calories")+"#"+Eval("Protein")+"#"+Eval("Sodium")+"#"+Eval("SaturatedFat")+"#"+Eval("T_Fat")+"#"+Eval("Calcium")+"#"+Eval("Iron")+"#"+Eval("Zinc")+"#"+Eval("ItemID")+"#"+Eval("Potassium")%>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="10%" />
                                </asp:TemplateField>
                                <asp:CommandField ShowSelectButton="True" ButtonType="Image" SelectImageUrl="~/Images/edit.png" SelectText="Edit" HeaderText="Edit">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="8%" />
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                </asp:CommandField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
