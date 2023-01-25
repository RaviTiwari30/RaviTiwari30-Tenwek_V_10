<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    MaintainScrollPositionOnPostback="true" CodeFile="DoctorEdit.aspx.cs" Inherits="Design_Doctor_DoctorEdit" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            var departmnt = $("#hfDepartment").val();
            BindDoctor(departmnt, function () { });
        });

        function BindAllDoctors() {
            var txt = $("#<%=cmbDept.ClientID%> option:selected").text();
                BindDoctor(txt, function () { });
        }

        function BindDoctor(department, callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../common/CommonService.asmx/BindDoctorWithoutUnit', { Department: department }, function (response) {
                $ddlDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'NAME', isSearchAble: true, selectedValue: 'Select' });

                callback($ddlDoctor.val());
            });
        }

        function ShowText() {
            var chk = document.getElementById('<%=chkLogin.ClientID %>');
            if (chk.checked == true)
                document.getElementById('<%=pnlLogin.ClientID %>').style.display = '';
            else
                document.getElementById('<%=pnlLogin.ClientID %>').style.display = 'none';
        }
        function validateDoc() {
            if ($('#<%=txtName.ClientID %>').val() == "") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Enter Name');
                $('#<%=txtName.ClientID %>').focus();
                return false;
            }
            if ($('#<%=ddldoctorgroup.ClientID %>').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Select Doctor Group');
                $('#<%=ddldoctorgroup.ClientID %>').focus();
                return false;
            }
            if ($('#<%=ddlSpecial.ClientID %> ').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Select Doctor Sepcilization');
                $('#<%=ddlSpecial.ClientID %>').focus();
                return false;
            }
            if ($('#<%=cmbDept.ClientID %>').val() == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Select Doctor Sepcilization');
                $('#<%=cmbDept.ClientID %>').focus();
                return false;
            }
            if ($('#<%=grdTime.ClientID %> tr').length == "0") {
                $('#<%=lblerrmsg.ClientID %>').text('Please Specify Day Or Date of Timings');
                $('#<%=btntimings.ClientID %>').focus();
                return false;
            }
            var iFlag = 0;
            if (($('#<%=chkMon.ClientID %>').is(':checked')) || ($('#<%=chkTues.ClientID %>').is(':checked')) || ($('#<%=chkWed.ClientID %>').is(':checked')) || ($('#<%=chkThur.ClientID %>').is(':checked')) || ($('#<%=chkFri.ClientID %>').is(':checked')) || ($('#<%=chkSat.ClientID %>').is(':checked')) || ($('#<%=chkSun.ClientID %>').is(':checked')))
                iFlag = 1;
            if (($('#<%=grdTime.ClientID %> tr').length == "0") && (iFlag == "0")) {
                $('#<%=lblerrmsg.ClientID %>').text('Please Specify Day Or Date of Timings');
                $('#<%=chkMon.ClientID %>').focus();
                return false;
            }
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }

        function SaveDocShareUnit(DocID) {
           // alert(DocID);
            $getDoctorShareDetails(function ($ShareData) {
                serverCall('Services/DocGrouprateMaster.asmx/SaveDoctorUnit', { ShareDetails: $ShareData, DoctorID: DocID }, function () {
                   // modelAlert("Doctor saved Successfully.");
                    //location.reload();
                    window.location.replace("ViewDoctorDetail.aspx");
                });
            });
        }

    </script>
    <div id="Pbody_box_inventory" style="text-align: left;">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Edit Clinician Registration</b><br />
            <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Doctor Details &nbsp;
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                  <%--  <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtType" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="0">Single</asp:ListItem>
                                <asp:ListItem Value="1">Unit</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>--%>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="cmbTitle" runat="server" TabIndex="1"
                                ToolTip="Select  Title" Width="66px">
                              <asp:ListItem Selected="True">Dr.</asp:ListItem>
								<asp:ListItem>RCO</asp:ListItem>
                                <asp:ListItem>KCHRN</asp:ListItem>
                                <asp:ListItem>Rev.</asp:ListItem>
                                <asp:ListItem>Past.</asp:ListItem>
                                <asp:ListItem>Mr.</asp:ListItem>
                                <asp:ListItem>Ms.</asp:ListItem>
                                <asp:ListItem>Miss</asp:ListItem>
                                <asp:ListItem>Mrs.</asp:ListItem>
                                <asp:ListItem></asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtName" runat="server" MaxLength="100" TabIndex="2" Width="142px" ClientIDMode="Static"></asp:TextBox>
                            <span style="color: red; font-size: 10px;" class="shat">*</span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor&nbsp;Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddldoctorgroup" runat="server" TabIndex="3" ToolTip="Select Doctor Type"
                                Width="94%">
                            </asp:DropDownList>
                            <span class="shat" style="color: red; font-size: 10px;">*</span>
                            <asp:HiddenField ID="hfType" runat="server" ClientIDMode="Static" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Phone
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPhone1" runat="server" MaxLength="20" TabIndex="3"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbtxtPhone" runat="server" FilterType="Numbers"
                                TargetControlID="txtPhone1">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Mobile
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="TxtMobileNo" runat="server" MaxLength="50" TabIndex="4" ></asp:TextBox>
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAdd" runat="server" MaxLength="50"
                                TabIndex="5" TextMode="MultiLine"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Specialization
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSpecial" runat="server" TabIndex="6" Width="213px">
                            </asp:DropDownList>
                            <span class="shat" style="color: red; font-size: 10px;">*</span>
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
                            <asp:DropDownList ID="cmbDept" runat="server" TabIndex="7"  onchange="BindAllDoctors();" >
                            </asp:DropDownList>
                            <span class="shat" style="color: red; font-size: 10px;">*</span>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Degree
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDocDegree" runat="server" MaxLength="50"></asp:TextBox>
                        </div>
                        <div class="col-md-3" style="display:none">
                            <label class="pull-left">
                                Doctor Share
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display:none">
                            <asp:RadioButtonList ID="rblDocShare" runat="server" ClientIDMode="Static" ToolTip="Click To Select" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row" >
                        <div class="col-md-3">
                            <label class="pull-left">
                                Emer. Available
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rblIsAvailableEmergency" runat="server" ClientIDMode="Static" ToolTip="Click To Select" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3" id="divlblDoctors">
                            <label class="pull-left">
                                Doctors
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" id="divDoctor">
                            <select id="ddlDoctor" class="" title="Select Doctor" style="">
                            </select>
                            <asp:HiddenField ID="hfDepartment" runat="server" ClientIDMode="Static"/>
                        </div>
                        <div class="col-md-3" id="lblPosition">
                            <label class="pull-left">
                               Position
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPosition"  >                              
                                <option value="1">Senior</option>
                                <option value="2">Junior</option>
                            </select>
                        </div>
                    </div>
                    <div class="row" id="divDoctorname">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor's Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <div id="divDoctorList" class="chosen-container-multi">
                                <table id="tblDoctorList" class="GridViewStyle" cellspacing="0" rules="all" border="1" >
                                    <thead class="GridViewHeaderStyle"></thead>
                                    <tbody></tbody>
                                </table>
                                <ul id="ulDocyorList" runat="server" clientidmode="Static" style="border: none; background-image: none; background-color: #F5F5F5; padding: 0" class="chosen-choices">
                                </ul>
                                
                            </div>
                        </div>
                    </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Slot Wise Token
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoIsSlotWiseToken" runat="server" ClientIDMode="Static" ToolTip="Click To Select" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Yes" Value="1" />
                                <asp:ListItem Text="No" Value="0" Selected="True" />
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Doc.TimeDisplay</label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDoctorTiminig" runat="server" TextMode="MultiLine" Height="40px"></asp:TextBox>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Cadre</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCadre" runat="server" class="requiredField"  ToolTip="Select Cadre" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Tier</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlTier" runat="server"  class="requiredField"  ToolTip="Select Tier" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <div class="row"></div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                OPD Schedule Details
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rbtnType" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rbtnType_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="1">By Days</asp:ListItem>
                                <asp:ListItem Value="2">By Date</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div id="trdy" runat="server" class="col-md-2">
                            <label class="pull-left">
                                Days
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div id="trDaysWise" runat="server" class="col-md-12">
                            <asp:CheckBox ID="chkMon" runat="server" Height="11px" TabIndex="8" Text="Mon" Width="72px" />
                            <asp:CheckBox ID="chkTues" runat="server" Height="11px" TabIndex="9" Text="Tues"
                                Width="75px" />
                            <asp:CheckBox ID="chkWed" runat="server" Height="11px" TabIndex="10" Text="Wed" Width="74px" />
                            <asp:CheckBox ID="chkThur" runat="server" Height="11px" TabIndex="11" Text="Thur"
                                Width="72px" />
                            <asp:CheckBox ID="chkFri" runat="server" Height="11px" TabIndex="12" Text="Fri" Width="62px" />
                            <asp:CheckBox ID="chkSat" runat="server" Height="11px" TabIndex="13" Text="Sat" Width="67px" />
                            <asp:CheckBox ID="chkSun" runat="server" Height="11px" TabIndex="14" Text="Sun" Width="70px" />
                        </div>
                        <div id="trdt" runat="server" class="col-md-2">
                            <label class="pull-left">
                                Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div id="trDateWise" runat="server" class="col-md-4">
                            <asp:TextBox ID="txtDate" ClientIDMode="Static" runat="server" ToolTip="Select Date" Width="129px"
                                TabIndex="1"></asp:TextBox>
                            <asp:CheckBox ID="chkRepeat" runat="server" Text="Repeat Date Every Month" Visible="false" />
                            <cc1:CalendarExtender ID="txtDate_CalendarExtender" runat="server" TargetControlID="txtDate"
                                Format="dd-MMM-yyyy" ClearTime="true">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">
                                Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlCentre" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Start Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtHr1" runat="server" CssClass="inputbox3" MaxLength="2" TabIndex="15"
                                Width="30px"></asp:TextBox><asp:TextBox ID="txtMin1" runat="server" CssClass="inputbox3"
                                    MaxLength="2" TabIndex="16" Width="30px"></asp:TextBox><asp:DropDownList ID="cmbAMPM1"
                                        runat="server" CssClass="inputcombobox" TabIndex="17" Width="55px">
                                        <asp:ListItem>AM</asp:ListItem>
                                        <asp:ListItem>PM</asp:ListItem>
                                    </asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="ftbe1" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtHr1">
                            </cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="ftbe2" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtMin1">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                End Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtHr2" runat="server" CssClass="inputbox3" MaxLength="2" TabIndex="18"
                                Width="30px"></asp:TextBox><asp:TextBox ID="txtMin2" runat="server" CssClass="inputbox3"
                                    MaxLength="2" TabIndex="19" Width="30px"></asp:TextBox><asp:DropDownList ID="cmbAMPM2"
                                        runat="server" CssClass="inputcombobox" TabIndex="20" Width="55px">
                                        <asp:ListItem>AM</asp:ListItem>
                                        <asp:ListItem>PM</asp:ListItem>
                                    </asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="ftbe3" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtHr2">
                            </cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="ftbe4" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtMin2">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Shift
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlDocTimingShift" runat="server" ToolTip="Select Shift" class="requiredField"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2"></div>
                        <div class="col-md-4">
                            <asp:Button ID="btntimings" runat="server" CssClass="ItDoseButton" OnClick="btntimings_Click"
                                TabIndex="23" Text="Add Timings" />
                        </div>

                        <div class="col-md-4">
                            <label class="pull-left">
                                Duration for Patient
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlduration" runat="server" TabIndex="22" Width="50px">
                                <asp:ListItem>5</asp:ListItem>
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>40</asp:ListItem>
                                <asp:ListItem>50</asp:ListItem>
                                <asp:ListItem>60</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;(In Minutes)
                        </div>
                        <div class="col-md-4">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddldurationOld" runat="server" TabIndex="23" Width="50px" Style="display: none;">
                                <asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>40</asp:ListItem>
                                <asp:ListItem>50</asp:ListItem>
                                <asp:ListItem>60</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <asp:GridView ID="grdTime" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                Height="54px" OnRowDeleting="grdTime_RowDeleting" Width="100%">
                                <Columns>

                                    <asp:BoundField DataField="CentreName" HeaderText="Centre" ItemStyle-Width="150px" />
                                    <asp:BoundField DataField="Day" HeaderText="Days" ItemStyle-Width="150px" />
                                    <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                                    <asp:BoundField DataField="EndTime" HeaderText="End Time" />
                                    <asp:BoundField DataField="AvgTime" HeaderText="Duration For Patient" />
                                    <asp:BoundField DataField="StartBufferTime" HeaderText="Start BT" Visible="false" />
                                    <asp:BoundField DataField="EndBufferTime" HeaderText="End BT" Visible="false" />
                                    <asp:BoundField DataField="ShiftName" HeaderText="Shift" />

                                    <asp:CommandField ShowDeleteButton="True" ButtonType="Button" ControlStyle-CssClass="ItDoseButton" />
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRepeat" runat="server" Text='<%#Eval("IsRepeat") %>'></asp:Label>
                                            <asp:Label ID="lblDate" runat="server" Text='<%#Eval("Date") %>'></asp:Label>
                                            <asp:Label ID="lblStartTime" runat="server" Text='<%#Eval("StartTime") %>'></asp:Label>
                                            <asp:Label ID="lblEndTime" runat="server" Text='<%#Eval("EndTime") %>'></asp:Label>
                                            <asp:Label ID="lblShiftName" runat="server" Text='<%#Eval("ShiftName") %>'></asp:Label>
                                            <asp:Label ID="lblCentreID" runat="server" Text='<%#Eval("CentreID") %>'></asp:Label>
                                            <asp:Label ID="lblDurationforOldPatient" runat="server" Text='<%#Eval("DurationforOldPatient") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <AlternatingRowStyle CssClass="GridViewItemStyle" />
                            </asp:GridView>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                </div>
            </div>

            <table style="width: 952px" runat="server">
                <tr runat="server" id="trBufferTime" visible="false">
                    <td style="width: 125px; text-align: right">&nbsp;:
                    </td>
                    <td style="width: 482px; text-align: left">
                        <asp:TextBox ID="txtStartBT" runat="server" Width="44px"></asp:TextBox>
                        (In Minutes)<cc1:FilteredTextBoxExtender ID="ftb5" runat="server" FilterType="Custom,Numbers"
                            TargetControlID="txtStartBT">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="width: 129px; text-align: right">End Buffer Time :
                    </td>
                    <td style="width: 233px; text-align: left">
                        <asp:TextBox ID="txtEndBT" runat="server" Width="44px"></asp:TextBox>
                        (In Minutes)<cc1:FilteredTextBoxExtender ID="ftb6" runat="server" FilterType="Custom,Numbers"
                            TargetControlID="txtEndBT">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                </tr>
            </table>
        </div>

    </div>
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">
            Not-Available Schedule Details
        </div>
        <div class="row">
            <div class="col-md-2">
                <label class="pull-left">
                    Centre
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-4">
                <asp:DropDownList ID="ddlNACentre" runat="server"></asp:DropDownList>
            </div>
            <div class="col-md-2">
                <label class="pull-left">
                    From Date
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-4">
                <asp:TextBox ID="txtNotAvailableDateFrom" runat="server"></asp:TextBox>
                <cc1:CalendarExtender ID="cdNAFrom" runat="server" TargetControlID="txtNotAvailableDateFrom"
                    Format="dd-MMM-yyyy">
                </cc1:CalendarExtender>
            </div>
            <div class="col-md-3">
                <label class="pull-left">
                    To Date
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-4">
                <asp:TextBox ID="txtNotAvailableDateTo" runat="server"></asp:TextBox>
                <cc1:CalendarExtender ID="cdNATo" runat="server" TargetControlID="txtNotAvailableDateTo" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
            </div>
            <div class="col-md-2">
                <label class="pull-left">
                </label>
                <b class="pull-right"></b>
            </div>
            <div class="col-md-4">
                <asp:Button ID="btnNASearch" runat="server" CssClass="ItDoseButton" OnClick="btnNASearch_Click" Text="Search" ToolTip="Click To Search" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-1"></div>
            <div class="col-md-22" style="max-height: 150px; overflow: auto;">
                <asp:GridView ID="grdNATiming" runat="server" AutoGenerateColumns="False" OnRowDataBound="grdNATiming_RowDataBound" CssClass="GridViewStyle" Style="margin-left: 0px" Width="100%">
                    <Columns>
                        <asp:TemplateField>
                            <HeaderStyle Width="10px" HorizontalAlign="Center" />
                            <ItemStyle Width="10px" HorizontalAlign="Center" />
                            <HeaderTemplate>
                                Select
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server" Width="10px" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderTemplate>
                                Date
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblCentre" runat="server" Text='<%#Eval("CentreName") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField>
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderTemplate>
                                Date
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblDateValue" runat="server" Text='<%#Eval("DateValue") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderTemplate>
                                Day
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lblDayValue" runat="server" Text='<%#Eval("DayValue") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderTemplate>From Time</HeaderTemplate>
                            <ItemTemplate>
                                <asp:TextBox ID="txtNAHr1" runat="server" Text="00" MaxLength="2" Width="33px" ToolTip="Enter End Time "></asp:TextBox>
                                <asp:TextBox ID="txtNAMin1" runat="server" Text="10" MaxLength="2" Width="33px" ToolTip="Enter Minutes"></asp:TextBox>
                                <asp:DropDownList ID="cmbNAAMPM1" runat="server" Width="57px" ToolTip="Select AM Or PM">
                                    <asp:ListItem>AM</asp:ListItem>
                                    <asp:ListItem>PM</asp:ListItem>
                                </asp:DropDownList>
                                <cc1:FilteredTextBoxExtender ID="ftbtxtNAHr1" runat="server" FilterType="Custom,Numbers"
                                    TargetControlID="txtNAHr1">
                                </cc1:FilteredTextBoxExtender>
                                <cc1:FilteredTextBoxExtender ID="ftbtxtNAMin1" runat="server" FilterType="Custom,Numbers"
                                    TargetControlID="txtNAMin1">
                                </cc1:FilteredTextBoxExtender>
                                <asp:RangeValidator ID="rangetxtNAHr1" runat="server" ControlToValidate="txtNAHr1" MinimumValue="0"
                                    MaximumValue="12" ErrorMessage="Invalid Hours Time" ForeColor="Red"></asp:RangeValidator>
                                <asp:RangeValidator ID="rangetxttxtNAMin1" runat="server" ControlToValidate="txtNAMin1"
                                    MinimumValue="0" MaximumValue="60" ErrorMessage="Invalid Min Time" ForeColor="Red"></asp:RangeValidator>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderTemplate>To Time</HeaderTemplate>
                            <ItemTemplate>
                                <asp:TextBox ID="txtNAHr2" runat="server" Text="11" MaxLength="2" Width="33px" ToolTip="Enter End Time "></asp:TextBox>
                                <asp:TextBox ID="txtNAMin2" runat="server" Text="50" MaxLength="2" Width="33px" ToolTip="Enter Minutes"></asp:TextBox>
                                <asp:DropDownList ID="cmbNAAMPM2" runat="server" Width="57px" ToolTip="Select AM Or PM">
                                    <asp:ListItem>AM</asp:ListItem>
                                    <asp:ListItem>PM</asp:ListItem>
                                </asp:DropDownList>
                                <cc1:FilteredTextBoxExtender ID="ftbtxtNAHr2" runat="server" FilterType="Custom,Numbers"
                                    TargetControlID="txtNAHr2">
                                </cc1:FilteredTextBoxExtender>
                                <cc1:FilteredTextBoxExtender ID="ftbtxtNAMin2" runat="server" FilterType="Custom,Numbers"
                                    TargetControlID="txtNAMin2">
                                </cc1:FilteredTextBoxExtender>
                                <asp:RangeValidator ID="rangetxtNAHr2" runat="server" ControlToValidate="txtNAHr2" MinimumValue="0"
                                    MaximumValue="12" ErrorMessage="Invalid Hours Time" ForeColor="Red"></asp:RangeValidator>
                                <asp:RangeValidator ID="rangetxttxtNAMin2" runat="server" ControlToValidate="txtNAMin2"
                                    MinimumValue="0" MaximumValue="60" ErrorMessage="Invalid Min Time" ForeColor="Red"></asp:RangeValidator>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblNADate" runat="server" Text='<%#Eval("NADate") %>'></asp:Label>
                                <asp:Label ID="lblNACentreID" runat="server" Text='<%#Eval("CentreID") %>'></asp:Label>
                                <asp:Label ID="lblIsCheck" runat="server" Text='<%#Eval("IsCheck") %>'></asp:Label>
                                <asp:Label ID="lblNAST" runat="server" Text='<%#Eval("ST") %>'></asp:Label>
                                <asp:Label ID="lblNAET" runat="server" Text='<%#Eval("ET") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                    <AlternatingRowStyle CssClass="GridViewItemStyle" />
                </asp:GridView>
            </div>
            <div class="col-md-1"></div>
        </div>
    </div>
    <div class="POuter_Box_Inventory" style="text-align: center;">
        <div class="row">
            <div class="col-md-3">
                <asp:CheckBox ID="chkLogin" runat="server" Text="Login Required" onClick="ShowText();" />
            </div>
            <div class="col-md-3">
                <label class="pull-left">
                    Digital Signature
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-3">
                <asp:FileUpload ID="fuDrSignature" runat="server" />
            </div> 
            <div class="col-md-1"></div>
            <div class="col-md-4">
                <asp:CheckBox ID="chkDoctorGroupRate" runat="server" Text="Follow Doctor Group Rate" Checked="false" />
            </div>
            <div class="col-md-2">
                <label class="pull-left">
                    Room No.
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-3">
                <asp:TextBox ID="txtRoomNo" runat="server" TabIndex="21"></asp:TextBox>
            </div>
            <div class="col-md-2">
                <label class="pull-left">
                    Floor
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-3">
                <asp:DropDownList ID="ddlDocFloor" runat="server"></asp:DropDownList>
            </div>
        </div>
        <div class="row">
            <asp:Panel ID="pnlLogin" runat="server" Style="display: none" Width="100%">
                <div class="col-md-3">
                    <label class="pull-left">
                        User Name
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-2"></div>
                <div class="col-md-2">
                    <label class="pull-left">
                        Password
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtPassword" runat="server"
                        TextMode="Password"></asp:TextBox>
                </div>
            </asp:Panel>
        </div>
    </div>
    <div class="POuter_Box_Inventory" style="text-align: center;">
        <asp:UpdatePanel ID="UP5" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnSave" EventName="Click" />
            </Triggers>
            <ContentTemplate>
                <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click" TabIndex="23" Text="Save" ToolTip="Click To Save" OnClientClick="return validateDoc()" />
            </ContentTemplate>
        </asp:UpdatePanel>
        
    </div>

    <script type="text/javascript">
        var unit;
        $(document).ready(function () {
            var doctorId = '<%= Util.GetString(Request.QueryString["DID"]) %>';
            var doctype = '<%= Util.GetString(Request.QueryString["IsUnit"]) %>';
            if (doctype == "1") {
                bindUnitDoctor(doctorId);
                BindDoctor("All", function () {
                    $('#divDoctor').css("display", "");
                    $('#lblDoctor').css("display", "");
                    $('#divlblDoctors').css("display", "");
                });
            }
            else {
                $('#divDoctor').css("display", "none");
                $('#divlblDoctors').css("display", "none");
                $('#lblDoctor').css("display", "none");
                $('#divDoctorname').css("display", "none");
                $('#ddlPosition').css("display", "none");
                $('#lblPosition').css("display", "none");
            }
        });

        var bindUnitDoctor = function (DoctorId) {
            $.ajax({
                url: 'DoctorEdit.aspx/GetUnitList',
                data: '{DoctorID:"' + DoctorId + '"}',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                timeout: 120000,
                dataType: 'json',
                async: false,
                success: function (resp) {
                    unit = JSON.parse(resp.d);
                   // if (unit.length > 0) {
                        bindSharedUnit(function () {
                            $('#<%=rblDocShare.ClientID%>' + '_0').attr('checked', 'checked')
                                showHideDoctorList("s");
                            });
                       // }
                       // else {
                       //     BindDoctorByUnitID(DoctorId, function () {
                         //       $('#<%=rblDocShare.ClientID%>' + '_1').attr('checked', 'checked')
                         //       showHideDoctorList("n");
                          //  });
                       //}
                    }
                })
        }

        var showHideDoctorList = function (unitType) {
          //  if (unitType == "s") {
                $('#ulDocyorList').css("display", "none");
                $('#tblDoctorList').css("display", "");
                $('#divDoctorList').css("display", "");
                $('#divDoctorname').css("display", "");
                $('#lblPosition').css("display", "");
                $('#ddlPosition').css("display", "");
            //}
            //else {
            //    $('#tblDoctorList').css("display", "none");
            //    $('#lblPosition').css("display", "none");
            //    $('#ddlPosition').css("display", "none");
            //    $('#ulDocyorList').css("display", "");
            //    $('#divDoctorname').css("display", "");
            //    $('#divDoctorList').css("display", "");
            //}
        }

        $('#ddlDoctor').change(function () {
            // check selected
            if ($(this).find('option:selected').val() == '0')
                return false;

            var id = $(this).find(':selected').val(), dname = $(this).find(':selected').text(), position = $('#ddlPosition').find(':selected').text();
            var doc = { docID: id, docName: dname, docPosition: position }

            addUnitDoctor(doc, function () {
                showHideDoctorList("s");
            });

           // if ($('#<%=rblDocShare.ClientID%>' + '_0').is(':checked')) {
                //    addUnitDoctor(doc, function () {
                //        showHideDoctorList("s");
                //    });
                //}
                //else {
                //    bindAdmissionDoctors(doc, function () {
                //        showHideDoctorList("n");
                //    });
                //}
         });

        var onRemoveDoctor = function (el) {
            $(el).closest('tr').remove();
            saveUnitDoctor();
            // update table sno.
            var c = 1; var gname = 'sharetype_' + c
            $('#tblDoctorList tbody').find('tr').each(function () {
                $(this).find('input[type=radio]').attr('name', 'sharetype_' + c)
                $(this).find('td:first-child').html(c++)
            })

            if ($('#tblDoctorList tbody').find('tr').length == 0) {
                $('#tblDoctorList tHead').find('tr').remove()
               // $('#lblPosition').css("display", "none");
               // $('#ddlPosition').css("display", "none");

                $('#lblPosition').css("display", "");
                $('#ddlPosition').css("display", "");
            }
        }

        var onRemoveFromList = function (ob) {
            $(ob).parent().remove()
        }

        $(function () {
            $('#<%=rblDocShare.ClientID%>' + '_0').change(function () {
                 if ($('#<%=ddldoctorgroup.ClientID%>').find(':selected').val() == "4") {
                    addDoctorToTable();
                    showHideDoctorList("s");
                    $('#lblPosition').css("display", "");
                    $('#ddlPosition').css("display", "");
                }
            })

             $('#<%=rblDocShare.ClientID%>' + '_1').change(function () {
                 if ($('#<%=ddldoctorgroup.ClientID%>').find(':selected').val() == "4") {
                     addDoctorToList();
                     showHideDoctorList("n");
                 }
                 //  $('#divDoctorname').css("display", "none");
               //  $('#lblPosition').css("display", "none");
              //   $('#ddlPosition').css("display", "none");

                 $('#lblPosition').css("display", "");
                 $('#ddlPosition').css("display", "");
             })
        });

        var addDoctorToTable = function () {

            $('#ulDocyorList').find('li').each(function () {
                var docId = $(this).attr('id')
                if (!isDocAdded(docId, $('#tblDoctorList'))) {
                    var doctorList = {
                        docID: docId,
                        docName: $(this).find('span').text(),
                        docPosition: "Senior"
                    }
                    addUnitDoctor(doctorList, function () { })
                }
            })
            showHideDoctorList("s");
        }

        function BindDoctorByUnitID(unitID, callback) {

            $.ajax({
                url: 'DoctorEdit.aspx/BindDoctorByUnitID',
                data: '{unitID:"' + unitID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
            }).done(function (response) {
                var xmlDoc = $.parseXML(response.d);
                var xml = $(xmlDoc);
                var customers = xml.find("Customers");
                var doctorList = $('#divDoctorList')

                $.each(customers, function () {
                    doctorList.find('ul').append('<li id=' + $(this).find("DoctorID").text() + ' class="search-choice"><span>' + $(this).find("NAME").text() + '</span><a onclick="$(this).parent().remove()" style="cursor:pointer" class="search-choice-close" data-option-array-index="4">' + $(this).find("DoctorID").text() + '</a></li>');
                });
                callback()
            });
        }

        var bindSharedUnit = function (callback) {
            // Add table header
            var tHead = $('#tblDoctorList thead')
            if (tHead.find('tr').length == 0) {
                var tHeadContent = '<tr>'
                tHeadContent += '<td style="width:20px">S.No.</td>'
                tHeadContent += '<td style="width:300px">Name</td>'
                tHeadContent += '<td style="width:100">Position</td>'
                //tHeadContent += '<td style="width:50px">OPD Con</td>'
                //tHeadContent += '<td style="width:50px">OPD Proc</td>'
                //tHeadContent += '<td style="width:50px">OPD Lab</td>'
                //tHeadContent += '<td style="width:50px">OPD Pac</td>'
                //tHeadContent += '<td style="width:50px">OPD Oth.</td>'
                //tHeadContent += '<td style="width:50px">IPD Visit</td>'
                //tHeadContent += '<td style="width:50px">IPD Proc</td>'
                //tHeadContent += '<td style="width:50px">IPD Lab</td>'
                //tHeadContent += '<td style="width:50px">IPD Sur</td>'
                //tHeadContent += '<td style="width:50px">IPD Pac</td>'
                //tHeadContent += '<td style="width:50px">IPD Oth.</td>'
                //tHeadContent += '<td style="width:100px">Per/Amt</td>'
                tHeadContent += '<td></td>'
                tHeadContent += '</tr>'
                tHead.append(tHeadContent);
            }
            // Add table body
            var tBody = $('#tblDoctorList tbody'); var tBodyContent = "";
            for (var c = 0; c < unit.length; c++) {
                var gname = 'sharetype_' + (c + 1);
                tBodyContent += '<tr id=' + unit[c].DoctorListId + ' tableid=' + (c + 1) + '>'
                tBodyContent += '<td>' + (c + 1) + '</td>'
                tBodyContent += '<td id="docName_' + (c + 1) + '"><span id="spnDocPos">' + unit[c].DoctorName + '</span></td>'
                tBodyContent += '<td id="docPos_' + (c + 1) + '">' + unit[c].position + '</td>'
                //tBodyContent += '<td id="opd_con_' + (c + 1) + '"><input value="' + unit[c].OPD_Con + '" id="txtopdcon_' + (c + 1) + '" type="text" /></td>'
                //tBodyContent += '<td id="opd_pro_' + (c + 1) + '"><input value="' + unit[c].OPD_Pro + '" type="text" id="txtopdpro_' + (c + 1) + '" /></td>'
                //tBodyContent += '<td id="opd_lab_' + (c + 1) + '"><input value="' + unit[c].OPD_Lab + '" type="text" id="txtopdlab_' + (c + 1) + '" /></td>'
                //tBodyContent += '<td id="opd_pac_' + (c + 1) + '"><input value="' + unit[c].OPD_Pac + '" type="text" id="txtopdpac_' + (c + 1) + '" /></td>'
                //tBodyContent += '<td id="opd_oth_' + (c + 1) + '"><input value="' + unit[c].OPD_Oth + '" style="width:50px" type="text" id="txtopdoth_' + (c + 1) + '" /></td>'
                //tBodyContent += '<td id="ipd_visit_' + (c + 1) + '"><input value="' + unit[c].IPD_Visit + '" type="text" id="txtipdvisit_' + (c + 1) + '" /></td>'
                //tBodyContent += '<td id="ipd_pro_' + (c + 1) + '"><input value="' + unit[c].IPD_Pro + '" type="text" id="txtipdpro_' + (c + 1) + '" /></td>'
                //tBodyContent += '<td id="ipd_lab_' + (c + 1) + '"><input value="' + unit[c].IPD_Lab + '" type="text" id="txtipdlab_' + (c + 1) + '" /></td>'
                //tBodyContent += '<td id="ipd_sur_' + (c + 1) + '"><input value="' + unit[c].IPD_Sur + '" type="text" id="txtipdsur_' + (c + 1) + '" /></td>'
                //tBodyContent += '<td id="ipd_pac_' + (c + 1) + '"><input value="' + unit[c].IPD_Pac + '" type="text" id="txtipdpac_' + (c + 1) + '" /></td>'
                //tBodyContent += '<td id="ipd_oth_' + (c + 1) + '"><input value="' + unit[c].IPD_Oth + '" style="width:50px" type="text" id="txtipdoth_' + (c + 1) + '" /></td>'
                //if (unit[c].IsPer == "1")
                //    tBodyContent += '<td><span><input type="radio" value="1" name="' + gname + '" checked="checked" onchange="onShareTypeChange(this)" />Amt</span><span><input type="radio" value="2" name="' + gname + '" onchange="onShareTypeChange(this)" />Per</span></td>'
                //else
                //    tBodyContent += '<td><span><input type="radio" value="1" name="' + gname + '" onchange="onShareTypeChange(this)" />Amt</span><span><input type="radio" value="2" name="' + gname + '" checked="checked" onchange="onShareTypeChange(this)" />Per</span></td>'

                tBodyContent += '<td><input type="button" value="Remove" onclick="onRemoveDoctor(this)" class="ItDoseButton" /></td>'
                tBodyContent += '</tr>'
            }
            tBody.append(tBodyContent)
            callback()
        }

        function UpdateActiveStatus(docID) {
            $.ajax({
                url: 'DoctorEdit.aspx/UpdateActive',
                data: '{id:"' + docID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
            }).done(function (r) {

            });
        }

        var isDocAdded = function (docId, ob) {
            var isExist = $(ob).find('#' + docId)
            if (isExist.length > 0)
                return true
        }

        var addUnitDoctor = function (doc, callback) {
            if (isDocAdded(doc.docID, $('#tblDoctorList'))) {
                modelAlert('Doctor Already Selected')
                return false;
            }

            // Add table header
            var tHead = $('#tblDoctorList thead')
            if (tHead.find('tr').length == 0) {
                var tHeadContent = '<tr>'
                tHeadContent += '<td style="width:20px">S.No.</td>'
                tHeadContent += '<td style="width:300px">Name</td>'
                tHeadContent += '<td style="width:100">Position</td>'
                //tHeadContent += '<td style="width:50px">OPD Con</td>'
                //tHeadContent += '<td style="width:50px">OPD Proc</td>'
                //tHeadContent += '<td style="width:50px">OPD Lab</td>'
                //tHeadContent += '<td style="width:50px">OPD Pac</td>'
                //tHeadContent += '<td style="width:50px">OPD Oth.</td>'
                //tHeadContent += '<td style="width:50px">IPD Visit</td>'
                //tHeadContent += '<td style="width:50px">IPD Proc</td>'
                //tHeadContent += '<td style="width:50px">IPD Lab</td>'
                //tHeadContent += '<td style="width:50px">IPD Sur</td>'
                //tHeadContent += '<td style="width:50px">IPD Pac</td>'
                //tHeadContent += '<td style="width:50px">IPD Oth.</td>'
                //tHeadContent += '<td style="width:100px">Per/Amt</td>'
                tHeadContent += '<td></td>'
                tHeadContent += '</tr>'
                tHead.append(tHeadContent);
            }
            // Add table data 

            var tBody = $('#tblDoctorList tbody')
            var i = tBody.find('tr').length;
            var gname = 'sharetype_' + ++i;
            var tBodyContent = '<tr id=' + doc.docID + ' tableid=' + i + '>'
            tBodyContent += '<td>' + i + '</td>'
            tBodyContent += '<td id="docName_' + i + '">' + doc.docName + '</td>'
            tBodyContent += '<td id="docPos_' + i + '"><span id="spnDocPos">' + doc.docPosition + '</span></td>'
            //tBodyContent += '<td id="opd_con_' + i + '"><input value="0" style="width:50px" id="txtopdcon_' + i + '"  type="text" /></td>'
            //tBodyContent += '<td id="opd_pro_' + i + '"><input value="0" style="width:50px" type="text" id="txtopdpro_' + i + '" /></td>'
            //tBodyContent += '<td id="opd_lab_' + i + '"><input value="0" style="width:50px" type="text" id="txtopdlab_' + i + '" /></td>'
            //tBodyContent += '<td id="opd_pac_' + i + '"><input value="0" style="width:50px" type="text" id="txtopdpac_' + i + '" /></td>'
            //tBodyContent += '<td id="opd_oth_' + i + '"><input value="0" style="width:50px" type="text" id="txtopdoth_' + i + '"  /></td>'
            //tBodyContent += '<td id="ipd_visit_' + i + '"><input value="0" style="width:50px" type="text" id="txtipdvisit_' + i + '" /></td>'
            //tBodyContent += '<td id="ipd_pro_' + i + '"><input value="0" style="width:50px" type="text" id="txtipdpro_' + i + '" /></td>'
            //tBodyContent += '<td id="ipd_lab_' + i + '"><input value="0" style="width:50px" type="text" id="txtipdlab_' + i + '" /></td>'
            //tBodyContent += '<td id="ipd_sur_' + i + '"><input value="0" style="width:50px" type="text" id="txtipdsur_' + i + '" /></td>'
            //tBodyContent += '<td id="ipd_pac_' + i + '"><input value="0" style="width:50px" type="text" id="txtipdpac_' + i + '" /></td>'
            //tBodyContent += '<td id="ipd_oth_' + i + '"><input value="0" style="width:50px" type="text" id="txtipdoth_' + i + '" /></td>'
            //tBodyContent += '<td><span><input type="radio" value="1" name="' + gname + '" onchange="onShareTypeChange(this)" />Amt</span><span><input type="radio" value="2" name="' + gname + '" checked="checked"  onchange="onShareTypeChange(this)" />Per</span></td>'


            tBodyContent += '<td><input type="button" value="Remove"  onclick="onRemoveDoctor(this)" class="ItDoseButton" /></td>'
            tBodyContent += '</tr>'
            tBody.append(tBodyContent);
            callback()
        }

        $getDoctorShareDetails = function (callback) {
            $data = new Array();

            $('#tblDoctorList tbody tr').each(function () {
                $rowid = $(this).closest('tr').attr('tableid');
                $data.push({
                    DoctorListId: $(this).closest('tr').attr('id'),
                    //IsPer: $("input[name='sharetype_" + $rowid + "']:checked").val(),
                    //OPD_Con: $('#txtopdcon_' + $rowid).val(),
                    //OPD_Pro: $('#txtopdpro_' + $rowid).val(),
                    //OPD_Lab: $('#txtopdlab_' + $rowid).val(),
                    //OPD_Pac: $('#txtopdpac_' + $rowid).val(),
                    //IPD_Visit: $('#txtipdvisit_' + $rowid).val(),
                    //IPD_Pro: $('#txtipdpro_' + $rowid).val(),
                    //IPD_Lab: $('#txtipdlab_' + $rowid).val(),
                    //IPD_Sur: $('#txtipdsur_' + $rowid).val(),
                    //IPD_Pac: $('#txtipdpac_' + $rowid).val(),
                    //OPD_Oth: $('#txtopdoth_' + $rowid).val(),
                    //IPD_Oth: $('#txtipdoth_' + $rowid).val(),
                    Position: $(this).closest('tr').find("#spnDocPos").text()
                });
            });
            callback($data);
        }

        $('#<%=ddldoctorgroup.ClientID%>').change(function () {
            var isUnit = '<%= Util.GetString(Request.QueryString["IsUnit"]) %>';
            if (isUnit == "1" && $(this).find('option:selected').val() == "4") {
                if ($('#<%=rblDocShare.ClientID%>' + '_0').is(":checked")) {
                    $('#ddlPosition').css("display", "")
                    $('#lblPosition').css("display", "")
                }
                $('#divDoctorname').css("display", "")
                $('#divDoctor').css("display", "")
                $('#lblDoctor').css("display", "")
                $("#hfType").val(1);
            }
            else {
                $('#divDoctorname').css("display", "none")
                $('#divDoctor').css("display", "none")
                $('#lblDoctor').css("display", "none")
                $('#ddlPosition').css("display", "none")
                $('#lblPosition').css("display", "none")
                $("#hfType").val(0);
            }
        });

        var addDoctorToList = function () {
            $('#tblDoctorList tbody').find('tr').each(function (i) {
                var doc = {
                    docID: $(this).attr('id'),
                    docName: $(this).find('#docName_' + (++i) + '').text()
                }
                //if (!isDocAdded(doc.docID, $('#ulDocyorList'))) {
                //    bindAdmissionDoctors(doc, function () { showHideDoctorList("n") });
                //}
            });

            showHideDoctorList("n");
        }
    </script>
</asp:Content>
