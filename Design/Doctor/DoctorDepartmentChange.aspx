<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="DoctorDepartmentChange.aspx.cs" Inherits="Design_Doctor_DoctorDepartmentChange" %>


<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        function ClickSelectbtn(e, btnName) {
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
        function validate() {
            if ($('#<%=ddlDepartmentPanel.ClientID %> option:selected').text() == "All") {
                alert("Select one Department.");
                return false;
            }
        }
        function validateDoc(btn) {
            document.getElementById('<%=btnSave1.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave1.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave1', '');

        }

        function validateView() {
            document.getElementById('<%=btnView.ClientID%>').disabled = true;
            document.getElementById('<%=btnView.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnView', '');
        }
        var openCopytoCentreModel = function (e) {
            e.preventDefault();
            panelID = $("[id*=cmbPanel]  option:selected").val()
            panelName = $("[id*=cmbPanel]  option:selected").text();
            CentreName = $("[id*=ddlCentre]  option:selected").text()
            CentreID = $("[id*=ddlCentre]  option:selected").val()

            var divCopytoCentre = $('#divCopytoCentre');
            divCopytoCentre.find('#lblPanelCopyFrom').text(panelName).attr('panelID', panelID);
            divCopytoCentre.find('#lblCentreCopyFrom').text(CentreName).attr('CentreID', CentreID);

            $('#divCopytoCentre #chkCentre').find('input[type=checkbox]').each(function () {
                if (this.value == $('#lblCentreCopyFrom').attr('CentreID')) {
                    $(this).prop('checked', true);
                    $(this).prop('disabled', true);
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
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Search Doctor Details</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" AutoCompleteType="Disabled"
                                ToolTip="Enter Doctor Name" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Clinic
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDept" runat="server" TabIndex="2"
                                ToolTip="Select Department">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Specialization
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSpecialization"
                                runat="server"
                                TabIndex="3" ToolTip="Select Specialization">
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="4"
                Text="Search" OnClick="btnSearch_Click"
                ToolTip="Click To Search" /> &nbsp;&nbsp;
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click" />
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Doctor Details
                </div>
                <asp:GridView ID="GridView1" runat="server" Width="100%" AutoGenerateColumns="False" OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                    OnPageIndexChanging="GridView1_PageIndexChanging" TabIndex="5" CssClass="GridViewStyle"
                    AllowPaging="true" PageSize="5">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Name" HeaderText="Name">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="250px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="380px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Specialization" HeaderText="Specialization">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="160px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="270px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Degree" HeaderText="Degree" Visible="false">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="160px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="270px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Department" HeaderText="Department">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="160px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="270px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Doctor Share" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblDocShare" runat="server" Text='<%# (Util.GetInt(Eval("IsDocShare"))==1?"Yes":"No") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:HyperLinkField HeaderText="Edit" Visible="false" Text="Edit" DataNavigateUrlFields="DID,updateFlag,IsUnit"
                            DataNavigateUrlFormatString="~/Design/Doctor/DoctorEdit.aspx?DID={0}&amp;updateFlag={1}&amp;IsUnit={2}"
                            NavigateUrl="~/Design/Doctor/DoctorEdit.aspx">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="5px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:HyperLinkField>
                        <asp:CommandField HeaderText="Edit" SelectText="Edit" ShowSelectButton="True">
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:CommandField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:Label ID="lblDID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"DID") %>'
                                    Visible="False"></asp:Label>
                                <asp:Label ID="lblDoctorName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Name") %>'
                                    Visible="False"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
        <asp:Panel ID="Panel2" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Department Change
                </div>
                <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Doctor Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblDNamePanel" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Department
                                     </label>
                            </div>
                            <div class="col-md-5">
                                
                                <asp:DropDownList ID="ddlDepartmentPanel" runat="server" TabIndex="2"
                                ToolTip="Select Department">
                            </asp:DropDownList>
                               
                            </div>
                            <div class="col-md-3">
                                
                                <asp:Button ID="btnSaveDept" runat="server" OnClick="btnSaveDept_Click" Text="Save" CssClass="ItDoseButton"
                                    ToolTip="Click To Save" OnClientClick="return validate()" />
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>
                                     </div>
            </asp:Panel>
        <asp:Panel ID="Panel1" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Department Change
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-8">
                            </div>
                            <div class="col-md-8">
                                <asp:RadioButton ID="rdbOPD" runat="server" GroupName="a" Text="OPD" AutoPostBack="True"
                                    OnCheckedChanged="rdbOPD_CheckedChanged" CssClass="ItDoseCheckboxlistSpl"
                                    ToolTip="Select OPD To Update" Checked="True" />&nbsp;
                            <asp:RadioButton ID="rdbIPD" runat="server" GroupName="a" Text="IPD" AutoPostBack="True"
                                OnCheckedChanged="rdbIPD_CheckedChanged"
                                CssClass="ItDoseCheckboxlistSpl" ToolTip="Select IPD To Update" />
                            </div>
                            <div class="col-md-8">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Doctor Name
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblDName" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblSubCat" runat="server" Text="SubCategory : " Visible="False"></asp:Label>
                                </label>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="cmbSubCategory" runat="server" CssClass="ItDoseDropdownbox"
                                    Visible="False" Width="256px" ToolTip="Select Sub Category">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                            </div>
                            <div class="col-md-5">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblPanel" runat="server" Text="Panel"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="cmbPanel" runat="server"
                                    ToolTip="Select Panel" AutoPostBack="true"
                                    OnSelectedIndexChanged="cmbPanel_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Schedule&nbsp;Charges
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlScheduleCharge" runat="server"
                                    AppendDataBoundItems="True"
                                    ToolTip="Select Schedule Charges">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    <asp:Label ID="lblCaseType" runat="server" Text="CaseType" Visible="false"></asp:Label>
                                </label>
                                <b runat="server" id="lblcolan" visible="false" class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:ListBox ID="cmbCaseType" runat="server" CssClass="ItDoseTextinputText" SelectionMode="Multiple"
                                    Visible="false" style="height:100px;"></asp:ListBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3"><label class="pull-left">Centre</label><b class="pull-right"></b></div>
                            <div class="col-md-5">  <asp:DropDownList ID="ddlCentre" runat="server" ToolTip="Select Centre">
                            </asp:DropDownList></div>
                        </div>
                        <div class="row">
                            <div class="col-md-10">
                            </div>
                            <div class="col-md-2">
                                <asp:Button ID="btnView" runat="server" OnClick="btnView_Click" Text="View" CssClass="ItDoseButton"
                                    ToolTip="Click To View" OnClientClick="return validateView()" />
                            </div>
                            <div class="col-md-12">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>

                <table border="0" style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width: 15%; text-align: right"></td>
                        <td colspan="3" style="text-align: left">
                            <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False">
                                <Columns>
                                    <asp:TemplateField HeaderText="Select">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkSelect" runat="server" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="30px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Name" HeaderText="Name">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="200px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Rate">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtRate" runat="server" Text='<%# Bind("Rate") %>' Width="92px"></asp:TextBox>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Is Scheduled">
                                        <ItemTemplate>
                                            <asp:CheckBox runat="server" ID="chkIsScheduled" Checked='<%# Util.GetBoolean(Eval("IsScheduled")) %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Kiosk" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkKiosk" runat="server" Text='<%# Eval("ShowFlag") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="General" Visible="false">
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="75px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkGeneral" runat="server" Text='<%# Eval("ShowFlag") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRateID" runat="server" Visible="False" Text='<%# DataBinder.Eval(Container.DataItem,"RateListID") %>'></asp:Label>
                                            <asp:Label ID="lblItemID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'
                                                Visible="False"></asp:Label>
                                            <asp:Label ID="lblSchedulecharge" runat="server" Text='<%# Eval("ScheduleChargeID") %>' />
                                            <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID") %>' />
                                            <asp:Label ID="lblDoctorID" runat="server" Text='<%# Eval("DoctorID") %>' />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" Width="50px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                        <td style="width: 35%">
                            <asp:CheckBox ID="ChkAllRoom" runat="server"
                                Text="Apply This Rate To All Rooms" ToolTip="Check To Apply Rates" Visible="false" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 15%; text-align: right"></td>
                        <td colspan="2" style="width: 35%"></td>
                        <td style="width: 15%; text-align: right"></td>
                        <td style="width: 35%"></td>
                    </tr>
                    <tr>
                        <td style="text-align: center;" colspan="5">
                           <%-- <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave1_Click" CssClass="ItDoseButton"
                                Visible="False" ToolTip="Click To Save" OnClientClick="return validateDoc(this)" />--%>
                             &nbsp;<asp:Button ID="btnSave" runat="server" CssClass="save margin-top-on-btn"
                    Text="Save" ToolTip="Click To Save" Visible="False" OnClientClick="openCopytoCentreModel(event);" />
                        </td>
                    </tr>
                </table>

            </div>
        </asp:Panel>
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
									
                                    <asp:Label ID="lblCentreCopyFrom" runat="server" class="pull-left patientInfo" ClientIDMode="Static"></asp:Label>
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
                     <asp:Button ID="btnSave1" runat="server" CssClass="save margin-top-on-btn" Text="Save" OnClientClick="return validateDoc(this);" OnClick="btnSave1_Click" />
					<button type="button" data-dismiss="divCopytoCentre" >Close</button>
				</div>
			</div>
		</div>
	</div>
</asp:Content>

