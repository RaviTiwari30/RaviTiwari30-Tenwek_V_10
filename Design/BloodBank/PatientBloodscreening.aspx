<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="PatientBloodScreening.aspx.cs" Inherits="Design_BloodBank_PatientBloodScreening" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#txtdatefrom').change(function () {
                ChkDate();
            });

            $('#txtdateTo').change(function () {
                ChkDate();
            });
        });

        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtdatefrom').val() + '",DateTo:"' + $('#txtdateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#btnSearch').removeAttr('disabled');
                    }
                }
            });
        }

        function clearAllField() {
            $(':text, textarea').val('');
        }
        $(document).ready(function () {
            BindBloodGroup();
        });
        function BindBloodGroup() {
            serverCall('Services/BloodBank.asmx/LoadBloodGroup', {}, function (response) {
                ddlBloodgroup = $('#ddlBloodGroup');
                ddlBloodgroup.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false,defaultValue: 'Select' });
            });
        }
        function SearchPatient() {
            var PatientID = $('#txtPatientId').val();
            var IPDNo = $('#txtIPDNo').val();
            var PName = $('#txtName').val();
            var BloodGroup = $('#ddlBloodGroup option:selected').text();
            var FromDate = $('#txtdatefrom').val();
            var ToDate = $('#txtdateTo').val();
            var PType = $('#rdbType input:checked').val();
            var IsScreen = $('#rbtIsScreen input:checked').val();
            serverCall('PatientBloodScreening.aspx/SearchPatient', { PType: PType, PatientID: PatientID, IPDNo: IPDNo, PName: PName, BloodGroup: BloodGroup, FromDate: FromDate, ToDate: ToDate, IsScreen: IsScreen }, function (response) {
                StockData = JSON.parse(response);
                if (StockData.length != 0) {
                    var output = $('#tb_Patient').parseTemplate(StockData);
                    $('#divOutPut').html(output);
                    $('#divOutPut').show();
                }
                else {
                    modelAlert('No Record Found');
                    $('#divOutPut').hide();
                }
            });
        }
        function chngcur() {
            document.body.style.cursor = 'pointer';

        }
        function SetScreening(rowID) {

            var UHID = $(rowID).closest('tr').find('#tdPatientID').text();
            var IPdNo = $(rowID).closest('tr').find('#tdIPDNO').text();
            var PName = $(rowID).closest('tr').find('#tdPName').text();
            var Component = $(rowID).closest('tr').find('#tdItemName').text();
            var BloodGroup = $(rowID).closest('tr').find('#tdBloodGroup').text();
            var ItemID = $(rowID).closest('tr').find('#tdItemID').text();
            var LedgerTnxNo = $(rowID).closest('tr').find('#tdLedgerTnxno').text();
            var BloodCollectionID = $(rowID).closest('tr').find('#tdBloodCollection_Id').text();
            var GroupingID = $(rowID).closest('tr').find('#tdGrouping_Id').text();
            var TransactionID = $(rowID).closest('tr').find('#tdTransactionID').text();
            var ScreenID = $(rowID).closest('tr').find('#tdScreenID').text();

            CheckPatientValidTime(TransactionID, ItemID, GroupingID, function (response) {

           

                if (response[0].isExist == "1" && response[0].isValid=="0") {
                    $('#divScreening #spnMsgPop').text('Can not Edit...Screening Time is More then 72 Hours..!!!');
                    $('#divScreening #btnSaveScreening').hide();
                }
                else if (response[0].isExist == "1" && response[0].isValid == "1") {
                    $('#divScreening #btnSaveScreening').hide();
                    $('#divScreening #btnUpdate').show();
                    $('#divScreening #spnMsgPop').text('');
                }
                else {
                    $('#divScreening #btnSaveScreening').show();
                    $('#divScreening #btnUpdate').hide();
                    $('#divScreening #spnMsgPop').text('');
                }
                
                    $('#divScreening #spnPatientID').text(UHID);
                    $('#divScreening #spnIPDNo').text(IPdNo);
                    $('#divScreening #spnPName').text(PName);
                    $('#divScreening #spnComponent').text(Component);
                    $('#divScreening #spnBloodGroup').text(BloodGroup);
                    $('#divScreening #spnItemID').text(ItemID);
                    $('#divScreening #spnLedgerTnxNo').text(LedgerTnxNo);
                    $('#divScreening #spnBloodCollectionID').text(BloodCollectionID);
                    $('#divScreening #spnGroupingID').text(GroupingID);
                    $('#divScreening #spnTransactionID').text(TransactionID);
                    $('#divScreening #spnEntryDateTime').text(response[0].EntryDateTime);
                    $('#divScreening #spnScreenID').text(ScreenID);
                    $('#divScreening #ddlCell1').val(response[0].Cell1);
                    $('#divScreening #ddlCell2').val(response[0].Cell2);
                    $('#divScreening #ddlCell3').val(response[0].Cell3);
                    $('#divScreening #ddlResult').val(response[0].Result);
                    $('#divScreening #txtRemark').val(response[0].Remarks);
                    $('#divScreening').showModel();

            });
        }

        var CheckPatientValidTime=function(TransactionID, ItemID, GroupingID,callback)
        {
            serverCall('PatientBloodScreening.aspx/CheckPatientValidTime', {TransactionID:TransactionID, ItemID:ItemID, GroupingID:GroupingID}, function (response) {
                responseData = JSON.parse(response);
                callback(responseData);
            });
        }
    </script>
    <script type="text/javascript">
        function SaveScreening(ScreenDetail) {
            serverCall('PatientBloodScreening.aspx/SaveScreening', { screendetail: [ScreenDetail] }, function (response) {
                Result = JSON.parse(response);
                if (Result == '0')
                    modelAlert('Error Occured. Contact to Administrator');
                else {
                    $('#divScreening').closeModel();
                    modelAlert('Screening Result Saved Successfully', function (response) {
                        SearchPatient();
                    });
                }
            });
        }
        function UpdateScreening(ScreenDetail) {
            serverCall('PatientBloodScreening.aspx/UpdateScreening', { screendetail: [ScreenDetail] }, function (response) {
                Result = JSON.parse(response);
                if (Result == '0')
                    modelAlert('Error Occured. Contact to Administrator');
                else {
                    $('#divScreening').closeModel();
                    modelAlert('Screening Result Updated Successfully', function (response) {
                        SearchPatient();
                    });
                }
            });
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Patient Blood Screening</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div id="divResult" class="POuter_Box_Inventory" style="display: none;">
            <asp:Label ID="lblNewDonationId" runat="server" Text=""></asp:Label>
            <asp:Label ID="lblSession" runat="server" Text=""></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" runat="server">
                Search Criteria
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbType" runat="server" TabIndex="1" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="OPD" Value="OPD"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                                <asp:ListItem Text="EMG" Value="EMG">EMG</asp:ListItem>
                                <asp:ListItem Selected="True" Value="ALL">ALL</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPatientId" runat="server" MaxLength="20" TabIndex="1"  ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtIPDNo" runat="server" MaxLength="50" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" TabIndex="3" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdatefrom" runat="server" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                            <cc1:CalendarExtender ID="calfrom" TargetControlID="txtdatefrom" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtdateTo" runat="server" ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                            <cc1:CalendarExtender ID="calto" TargetControlID="txtdateTo" Format="dd-MMM-yyyy"
                                Animated="true" runat="server">
                            </cc1:CalendarExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBloodGroup" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Screening
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtIsScreen" runat="server" TabIndex="1" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-9"></div>
                <div class="col-md-6" style="text-align: center;">
                    <input type="button" id="btnSearch" value="Search" title="Click to Search" onclick="SearchPatient()" />
                </div>
                <div class="col-md-9"></div>
            </div>
        </div>
 
        <div class="POuter_Box_Inventory" style="text-align: center;">
               <div class="row">
                         <div id="divOutPut" style="max-height: 250px; overflow-x: auto;"></div>
             </div>
            </div>
    </div>

     <script id="tb_Patient" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_PatientData" style="width:100%;border-collapse:collapse;">
		<tr id="trHeader">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">IPD No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Age/Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Room</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Component</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Quantity</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">BloodGroup</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Select</th>
		</tr>
        <#       
        var dataLength=StockData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = StockData[j];
        #>
                <tr id="tr1">                            
                    <td class="GridViewLabItemStyle" id="tdID" style="width:30px; text-align:center;"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdType" style="width:30px; text-align:center;"><#=objRow.Type#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID" style="width:30px; text-align:center;"><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdIPDNO" style="width:30px; text-align:center;"><#=objRow.IPDNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPName" style="width:30px; text-align:center;"><#=objRow.Pname#></td>
                    <td class="GridViewLabItemStyle" id="tdAgeSex" style="width:30px; text-align:center;"><#=objRow.AgeSex#></td>
                    <td class="GridViewLabItemStyle" id="tdWard" style="width:30px; text-align:center;"><#=objRow.ward#></td>
                    <td class="GridViewLabItemStyle" id="tdItemName" style="width:120px; text-align:center;"><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle" id="tdQty" style="width:30px; text-align:center;"><#=objRow.Quantity#></td>
                    <td class="GridViewLabItemStyle" id="tdBloodGroup" style="width:30px; text-align:center;"><#=objRow.BloodGroup#></td>
                    <td class="GridViewLabItemStyle" id="tdLedgerTnxno" style="width:30px; text-align:center; display:none;"><#=objRow.LedgerTransactionNo#></td>
                    <td class="GridViewLabItemStyle" id="tdTransactionID" style="width:30px; text-align:center; display:none;"><#=objRow.TransactionID#></td>
                    <td class="GridViewLabItemStyle" id="tdItemID" style="width:30px; text-align:center; display:none;"><#=objRow.ItemID#></td>
                    <td class="GridViewLabItemStyle" id="tdBloodCollection_Id" style="width:30px; text-align:center; display:none;"><#=objRow.BloodCollection_Id#></td>
                    <td class="GridViewLabItemStyle" id="tdGrouping_Id" style="width:30px; text-align:center; display:none;"><#=objRow.Grouping_Id#></td>
                    <td class="GridViewLabItemStyle" id="tdScreenID" style="width:30px; text-align:center; display:none;"><#=objRow.ID#></td>
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center;"><img id="imgSelect" src="../../Images/Post.gif" onclick="SetScreening(this);" title="Click To Set Screening" onmouseover="chngcur()" /></td>
                </tr>           
        <#}#>                     
     </table>    
    </script>

    <div id="divScreening" tabindex="-1" role="dialog" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white; width:700px">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divScreening" area-hidden="true">&times;</button>
                    <h4 class="modal-title">Set Screening</h4>
                </div>
                <div class="modal-body">
                    <div class="row"><div class="col-md-24"><b><span id="spnMsgPop" style="color: Red;"></span></b></div></div>
                    <div class="row">
						 <div class="col-md-5">
							   <label class="pull-left patientInfo">UHID</label>
							   <b class="pull-right">:</b>
						  </div>
                        <div  class="col-md-7" >
							  <span id="spnPatientID" class="patientInfo"></span>
						  </div>
                        <div class="col-md-5">
							   <label class="pull-left patientInfo">IPD No.</label>
							   <b class="pull-right">:</b>
						  </div>
                        <div  class="col-md-7" >
							  <span id="spnIPDNo" class="patientInfo"></span>
						  </div>
                    </div>
                    <div class="row">
						 <div class="col-md-5">
							   <label class="pull-left patientInfo">Patient Name</label>
							   <b class="pull-right">:</b>
						  </div>
                        <div  class="col-md-7" >
							  <span id="spnPName" class="patientInfo"></span>
						  </div>
                        <div class="col-md-5">
							   <label class="pull-left patientInfo">Component</label>
							   <b class="pull-right">:</b>
						  </div>
                        <div  class="col-md-7" >
							  <span id="spnComponent" class="patientInfo"></span>
						  </div>
                    </div>
                    <div class="row">
						 <div class="col-md-5">
							   <label class="pull-left patientInfo">Blood Group</label>
							   <b class="pull-right">:</b>
						  </div>
                        <div  class="col-md-7" >
							    <span id="spnBloodGroup" class="patientInfo"></span>
                                <span id="spnItemID" style="display:none;"></span>
                                <span id="spnLedgerTnxNo" style="display:none;"></span>
                                <span id="spnBloodCollectionID" style="display:none;"></span>
                                <span id="spnGroupingID" style="display:none;"></span>
                                <span id="spnTransactionID" style="display:none;"></span>
                                <span id="spnScreenID" style="display:none;"></span>
						  </div>
                        <div class="col-md-5">
							   <label class="pull-left patientInfo">Entry DateTime</label>
							   <b class="pull-right">:</b>
						  </div>
                        <div  class="col-md-7" >
                                <span id="spnEntryDateTime" class="patientInfo"></span>
                        </div>
                    </div>
                    <div class="row">
                        <table cellspacing="0" rules="all" border="1"  id="tb_ScreenDetail" style="width:100%;border-collapse:collapse;">
                            <tr>
                                <th class="GridViewHeaderStyle">CELL I</th>
                                <th class="GridViewHeaderStyle">CELL II</th>
                                <th class="GridViewHeaderStyle">CELL III</th>
                                <th class="GridViewHeaderStyle" style="width:125px">Over All Result</th>
                            </tr>
                            <tr>
                                <td>
                                    <select id="ddlCell1">
                                        <option value="0">0</option>
                                        <option value="1">1+</option>
                                        <option value="2">2+</option>
                                        <option value="3">3+</option>
                                        <option value="4">4+</option>
                                    </select>
                                </td>
                                <td>
                                    <select id="ddlCell2">
                                        <option value="0">0</option>
                                        <option value="1">1+</option>
                                        <option value="2">2+</option>
                                        <option value="3">3+</option>
                                        <option value="4">4+</option>
                                    </select>
                                </td>
                                <td>
                                    <select id="ddlCell3">
                                        <option value="0">0</option>
                                        <option value="1">1+</option>
                                        <option value="2">2+</option>
                                        <option value="3">3+</option>
                                        <option value="4">4+</option>
                                    </select>
                                </td>
                                <td>
                                    <select id="ddlResult">
                                        <option value="N">N</option>
                                        <option value="P">P</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td><b><span id="spnRemark">Remarks</span></b></td>
                                <td colspan="3">
                                    <input type="text" id="txtRemark" maxlength="100" placeholder="Enter Remark Here" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                 <div class="modal-footer">
                         <button type="button" id="btnSaveScreening" onclick="SaveScreening({PatientID:$('#spnPatientID').text(),TransactionID:$('#spnTransactionID').text(),Component:$('#spnComponent').text(),BG:$('#spnBloodGroup').text(),ItemID:$('#spnItemID').text(),LTNo:$('#spnLedgerTnxNo').text(),BCID:$('#spnBloodCollectionID').text(),GroupID:$('#spnGroupingID').text(),CellI:$('#ddlCell1').val(),CellII:$('#ddlCell2').val(),CellIII:$('#ddlCell3').val(),Result:$('#ddlResult').val(),Remarks:$('#txtRemark').val()})">Save</button>
						 <button type="button" id="btnUpdate" style="display:none;" onclick="UpdateScreening({PatientID:$('#spnPatientID').text(),TransactionID:$('#spnTransactionID').text(),Component:$('#spnComponent').text(),BG:$('#spnBloodGroup').text(),ItemID:$('#spnItemID').text(),LTNo:$('#spnLedgerTnxNo').text(),BCID:$('#spnBloodCollectionID').text(),GroupID:$('#spnGroupingID').text(),CellI:$('#ddlCell1').val(),CellII:$('#ddlCell2').val(),CellIII:$('#ddlCell3').val(),Result:$('#ddlResult').val(),Remarks:$('#txtRemark').val(),ScreenID:$('#spnScreenID').text()})">Update</button>
                         <button type="button"  data-dismiss="divScreening" >Close</button>
				</div>
            </div>
        </div>
    </div>
</asp:Content>
