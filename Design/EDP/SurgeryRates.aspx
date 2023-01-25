<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SurgeryRates.aspx.cs" Inherits="Design_EDP_SurgeryRates"
    MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        var openCopytoCentreModel = function (e) {
            e.preventDefault();
            panelID = $("[id*=ddlPanelCompany]  option:selected").val()
            panelName = $("[id*=ddlPanelCompany]  option:selected").text();
            CentreName = $("[id*=ddlCentre]  option:selected").text()
            CentreID = $("[id*=ddlCentre]  option:selected").val()

            var divCopytoCentre = $('#divCopytoCentre');
            divCopytoCentre.find('#lblPanelCopyFrom').text(panelName).attr('panelID', panelID);
            divCopytoCentre.find('#lblCentreCopyFrom').text(CentreName).attr('CentreID', CentreID);

            $('#divCopytoCentre #chkCentre').find('input[type=checkbox]').each(function () {
                if (this.value == $('#lblCentreCopyFrom').attr('CentreID')) {
                    $(this).prop('checked', true);
                    $(this).prop('disabled',true);
                }
                else {
                    $(this).prop('checked', false);
                }
            });
            divCopytoCentre.showModel();
        }
        var CloseCopytoCentreModel = function () {
            $('#divCopytoCentre').closeModel();
        }

    </script>


    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">

            <div style="text-align: center;">
                <b>Surgery Rate List</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbDept" runat="server" RepeatDirection="Horizontal"
                                CssClass="ItDoseRadiobuttonlist" OnSelectedIndexChanged="rdbDept_SelectedIndexChanged"
                                AutoPostBack="True">
                                <asp:ListItem Value="0">OPD</asp:ListItem>
                                <asp:ListItem Value="1" Selected="True">IPD</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkSubCat" runat="server" Checked="True" Text="Departments" TextAlign="Left" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSubCategory" runat="server" AutoPostBack="True">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkItemSearch" runat="server" Checked="True" Text="Surgery Name" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSearchName" runat="server" Height="22px">
                            </asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-8">
                           <asp:RadioButtonList ID="rbtItemChar" runat="server" RepeatDirection="Horizontal"
                            CssClass="ItDoseRadiobuttonlist" AutoPostBack="True">
                            <asp:ListItem Selected="True" Value="0">By Initial Characters</asp:ListItem>
                            <asp:ListItem Value="1">By Middle Characters</asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Available Surgery
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:ListBox ID="lstItem" runat="server" CssClass="opdsearchbox2" Height="106px"
                            SelectionMode="Multiple" Width="344px"></asp:ListBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                 <asp:Button ID="btnLoadItem" runat="server" CssClass="ItDoseButton" Text="<< Load Items"
                            OnClick="btnLoadItem_Click" Width="102px" />
                            </label>
                        </div>
                        
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;">
            
               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkPanel" runat="server" Checked="True" Text="Panel" TextAlign="Left" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:ListBox ID="ddlPanelCompany" runat="server" style="margin-top:0px;" CssClass="ItDoseDropdownbox"
                                AutoPostBack="true" OnSelectedIndexChanged="ddlPanelCompany_SelectedIndexChanged"></asp:ListBox>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                <asp:CheckBox ID="chkRoomType" runat="server" Checked="True" Text="RoomType" TextAlign="Left" />
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:ListBox ID="cmbCaseType" runat="server" style="margin-top:0px;" CssClass="ItDoseDropdownbox"></asp:ListBox>
                        </div>
                            <div class="col-md-8">
                            <asp:RadioButtonList ID="rbtRateType" runat="server" CssClass="ItDoseRadiobuttonlist"
                                RepeatDirection="Horizontal" OnSelectedIndexChanged="rbtRateType_SelectedIndexChanged"
                                AutoPostBack="True">
                                <asp:ListItem Selected="True" Value="1">Rate Not Fixed</asp:ListItem>
                                <asp:ListItem Value="0">Rate Fixed</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Schedule Charges
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlScheduleCharge" style="margin-top:0px;" runat="server" AutoPostBack="True" CssClass="ItDoseDropdownbox"
                                OnSelectedIndexChanged="ddlScheduleCharge_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                          <div class="col-md-3">
                               <label class="pull-left">
                               Centre 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:DropDownList ID="ddlCentre" runat="server" ToolTip="Select Centre" AutoPostBack="true" OnSelectedIndexChanged="ddlCentre_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-8">
                             <asp:RadioButtonList ID="rbtActive" runat="server" CssClass="ItDoseRadiobuttonlist"
                                RepeatDirection="Horizontal"  AutoPostBack="True" Visible="False"
                                OnSelectedIndexChanged="rbtActive_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="1">Active Rates</asp:ListItem>
                                <asp:ListItem Value="0">In-Active Rates</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24" style="text-align:center;">
                             <asp:Button ID="btnRate" runat="server" CssClass="ItDoseButton" Text="Show Rates"
                                OnClick="btnRate_Click" />
                            </div>
                        </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div style="vertical-align: middle; text-align: left">
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                RateList Details
            </div>
            <div>
                <div style="overflow: auto; height: 192px; width: 100%;">
                    &nbsp;<asp:GridView ID="grdItemOPD" runat="server" Width="100%" Height="74px" CssClass="GridViewStyle"
                        AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Department" HeaderText="Department">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="SurgeryName" HeaderText="Surgery Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:BoundField>
                             <asp:TemplateField HeaderText="Surgery Rate">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle"  />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtRate" runat="server" Text='<%# Bind("Rate") %>' Width="66px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                             <asp:TemplateField HeaderText="Surgeon Rate">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtSurgeonRate" runat="server" Text='<%# Bind("surgeonRate") %>' Width="66px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="SurgeryCode">
                                <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtItemCode" runat="server" Text='<%# Eval("SurgeryCode") %>' Width="99px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Active Item">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:RadioButtonList ID="rbtActive" runat="server" RepeatDirection="Horizontal" SelectedValue='<%# Eval("IsCurrent") %>'>
                                        <asp:ListItem Value="1">Yes</asp:ListItem>
                                        <asp:ListItem Value="0">No</asp:ListItem>
                                    </asp:RadioButtonList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="False">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblSurgery_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Surgery_ID") %>'></asp:Label>
                                    <asp:Label ID="lblID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                    <asp:GridView ID="grdItemIPD" runat="server" Height="74px" Width="100%" CssClass="GridViewStyle"
                        AutoGenerateColumns="False">
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Department" HeaderText="Department">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Surgeryname" HeaderText="Surgery Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="RoomType" HeaderText="RoomType">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Surgery Rate">
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtRate" runat="server" Text='<%# Bind("Rate") %>' Width="66px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                             <asp:TemplateField HeaderText="Surgeon Rate">
                                <ItemStyle HorizontalAlign="Right" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtSurgeonRate" runat="server" Text='<%# Bind("surgeonRate") %>' Width="66px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="SurgeryCode">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtItemCode" runat="server" Text='<%# Eval("SurgeryCode") %>' Width="99px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Active Item">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:RadioButtonList ID="rbtActive" runat="server" RepeatDirection="Horizontal" SelectedValue='<%# Eval("IsCurrent") %>'>
                                        <asp:ListItem Value="1">Yes</asp:ListItem>
                                        <asp:ListItem Value="0">No</asp:ListItem>
                                    </asp:RadioButtonList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="False">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:Label ID="lblSurgery_ID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Surgery_ID") %>'></asp:Label>
                                    <asp:Label ID="lblID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ID") %>'></asp:Label>
                                    <asp:Label ID="lblCaseTypeID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"IPDCaseType_ID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    </asp:GridView>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="vertical-align: middle; text-align: center">
                <asp:CheckBox ID="chkToAllRooms" runat="server" Text="Set Rate To RoomTypes" TextAlign="Left" />
                &nbsp;
                <asp:Button ID="btnSave" runat="server" CssClass="save margin-top-on-btn"
                    Text="Save" ToolTip="Click To Save" OnClientClick="openCopytoCentreModel(event);" />

            </div>
        </div>
    </div>
      <div id="divCopytoCentre" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="min-width: 650px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divCopytoCentre" aria-hidden="true">&times;</button>
					<b class="modal-title">Copy Rates to other Centre</b>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-1"></div>
						<div class="col-md-22">
							<div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										From Panel Name
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<label id="lblPanelCopyFrom" class="pull-left patientInfo">
									</label>

								</div>
							</div>
                            <div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										From Centre Name
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
									<label id="lblCentreCopyFrom" class="pull-left patientInfo">
									</label>

								</div>
							</div>
							<div class="row">
								<div class="col-md-8">
									<label class="pull-left">
										Select  Centre To Copy
									</label>
									<b class="pull-right">:</b>
								</div>
								<div class="col-md-16">
								<asp:CheckBoxList ID="chkCentre" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static" CssClass="ItDoseCheckboxlist"></asp:CheckBoxList>
								</div>
							</div>
						</div>
						<div class="col-md-1"></div>
					</div>
				</div>
				<div class="modal-footer">
                     <asp:Button ID="btnSave1" runat="server" CssClass="save margin-top-on-btn" Text="Save" ToolTip="Click To Save" OnClick="btnSave1_Click" />
					<button type="button" data-dismiss="divCopytoCentre" >Close</button>
				</div>
			</div>
		</div>
	</div>
</asp:Content>
