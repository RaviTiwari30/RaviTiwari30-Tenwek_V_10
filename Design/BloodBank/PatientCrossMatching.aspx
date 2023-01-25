<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientCrossMatching.aspx.cs" Inherits="Design_BloodBank_PatientCrossMatching" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
           // BindBloodGroup();
        });
        //function BindBloodGroup() {
        //    serverCall('Services/BloodBank.asmx/LoadBloodGroup', {}, function (response) {
        //        ddlBloodgroup = $('#ddlBloodGroup');
        //        ddlBloodgroup.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });
        //    });
        //}

        function BindBagDropDown(Bloodgroup, componentid, ItemID) {
            serverCall('PatientCrossMatching.aspx/BindBag', { bloodgroup: Bloodgroup, ComponentID: componentid, ItemId: ItemID }, function (responce) {
                ddlbloodbagnum = $('#ddlbloodbagnum');
                ddlbloodbagnum.bindDropDown({ defaultValue: 'Select', data: JSON.parse(responce), valueField: 'ID', textField: 'BBTubeNo', isSearchAble: false });
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
            var sex = $("#ddlSex option:selected").val();
            var age = $.trim($("#txtAgeFrom").val());
            var year = $("#ddlAgefrom option:selected").text();
            serverCall('PatientCrossMatching.aspx/SearchPatient', { PType: PType, PatientID: PatientID, IPDNo: IPDNo, PName: PName, BloodGroup: BloodGroup, FromDate: FromDate, ToDate: ToDate, Sex: sex, Age: age, Year: year }, function (response) {
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

            var componentid = $(rowID).closest('tr').find('#tdComponentID').text();
            var ItemID = $(rowID).closest('tr').find('#tdItemID').text();
            var LedgerTnxNo = $(rowID).closest('tr').find('#tdLedgerTnxno').text();
            var BloodCollectionID = $(rowID).closest('tr').find('#tdBloodCollection_Id').text();
            var GroupingID = $(rowID).closest('tr').find('#tdGrouping_Id').text();
            var TransactionID = $(rowID).closest('tr').find('#tdTransactionID').text();

            CheckPatientValidTime(LedgerTnxNo, ItemID, UHID, function (response) {
                if (response[0].isExist=="1" && response[0].isValid == "1") {
                    $('#divScreening #spnMsgPop').text('Can not Edit... Time is More then 48 Hours..!!!');
                    $('#divScreening #btnSaveScreening').attr("disabled", true);
                    $('#divScreening #CheckPatientExists').text('1');
                }
                else if (response[0].isExist == "1" && response[0].isValid == "0") {
                    $('#divScreening #spnMsgPop').text('');
                    $('#divScreening #CheckPatientExists').text('1');
                    BindBagDropDown(BloodGroup, componentid, ItemID);
                }    
                else {
                    $('#divScreening #CheckPatientExists').text('');
                    BindBagDropDown(BloodGroup, componentid, ItemID);
                }//
                //else if (response[0].isValid == "1") {
                //    $('#divScreening #btnSaveScreening').hide();
                //    $('#divScreening #btnUpdate').show();
                //    $('#divScreening #spnMsgPop').text('');
                //}
                //else {
                //    $('#divScreening #btnSaveScreening').show();
                //    $('#divScreening #btnUpdate').hide();
                //    $('#divScreening #spnMsgPop').text('');
                //}

                  
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
                $('#divScreening #spnComponentID').text(componentid);

                $('#divScreening').showModel();

            });

            
        }

        var CheckPatientValidTime = function (LedgerTnxNo, ItemID, UHID, callback) {
            serverCall('PatientCrossMatching.aspx/CheckPatientValidTime', { LedgerTransactionNo: LedgerTnxNo, ItemID: ItemID, PatientID: UHID }, function (response) {
                responseData = JSON.parse(response);
                callback(responseData);
            });
        }
    </script>
    <script type="text/javascript">
        function SaveScreening(ScreenDetail) {

            serverCall('PatientBloodScreening.aspx/SaveScreening', { screendetail: [ScreenDetail] }, function (response) {

            });
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

<div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Patient Cross Match</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div id="divResult" class="POuter_Box_Inventory" style="display: none;">
            <asp:Label ID="lblNewDonationId" runat="server" Text=""></asp:Label>
            <asp:Label ID="lblSession" runat="server" Text=""></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div id="Div1" class="Purchaseheader" runat="server">
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
                                Age
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAgeFrom" runat="server" MaxLength="3" title="Enter Age From" Width="71px" ClientIDMode="Static"></asp:TextBox>
                            <asp:DropDownList ID="ddlAgefrom" runat="server" Width="148px" ClientIDMode="Static">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                <asp:ListItem Value="DAYS(S)">DAYS(S)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <%--<div class="col-md-3">
                            <label class="pull-left">
                                Age To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAgeTo" runat="server" MaxLength="3" title="Enter Age To" Width="71px"></asp:TextBox>
                            <asp:DropDownList ID="ddlAgeTo" runat="server" Width="148px">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                <asp:ListItem Value="DAYS(S)">DAYS(S)</asp:ListItem>
                            </asp:DropDownList>
                        </div>--%>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Sex
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSex" runat="server" ClientIDMode="Static">
                                <asp:ListItem Value="All">All</asp:ListItem>
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                                <asp:ListItem Value="Other">Other</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <%--<div class="col-md-3">
                            <label class="pull-left">
                                Sex
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSex" runat="server">
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                                <asp:ListItem Value="Other">Other</asp:ListItem>
                            </asp:DropDownList>
                        </div>--%>
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
            <%--<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">IPD No</th>--%>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Patient Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Age/Sex</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">IPD No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">BloodGroup</th>
           <%-- <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Room</th>--%>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Component</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Quantity</th>
            
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
                   <%-- <td class="GridViewLabItemStyle" id="tdType" style="width:30px; text-align:center;"><#=objRow.Type#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID" style="width:30px; text-align:center;"><#=objRow.Patient_ID#></td>
                    <td class="GridViewLabItemStyle" id="tdIPDNO" style="width:30px; text-align:center;"><#=objRow.IPDNo#></td>--%>
                    <td class="GridViewLabItemStyle" id="tdPName" style="width:30px; text-align:center;"><#=objRow.Pname#></td>
                    <td class="GridViewLabItemStyle" id="tdAgeSex" style="width:30px; text-align:center;"><#=objRow.AgeSex#></td>
                    <td class="GridViewLabItemStyle" id="tdIPDNO" style="width:30px; text-align:center;"><#=objRow.IPDNo#></td>
                    <td class="GridViewLabItemStyle" id="tdBloodGroup" style="width:30px; text-align:center;"><#=objRow.BloodGroup#></td>
                <%--    <td class="GridViewLabItemStyle" id="tdWard" style="width:30px; text-align:center;"><#=objRow.ward#></td>--%>
                    <td class="GridViewLabItemStyle" id="tdItemName" style="width:120px; text-align:center;"><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle" id="tdQty" style="width:30px; text-align:center;"><#=objRow.Quantity#></td>
                    
                    <td class="GridViewLabItemStyle" id="tdLedgerTnxno" style="width:30px; text-align:center; display:none;"><#=objRow.LedgerTransactionNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPatientID" style="width:30px; text-align:center;display:none;"><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdTransactionID" style="width:30px; text-align:center; display:none;"><#=objRow.TransactionID#></td>
                    <td class="GridViewLabItemStyle" id="tdItemID" style="width:30px; text-align:center; display:none;"><#=objRow.ItemID#></td>
                    <td class="GridViewLabItemStyle" id="tdBloodCollection_Id" style="width:30px; text-align:center; display:none;"><#=objRow.BloodCollection_Id#></td>
                    <td class="GridViewLabItemStyle" id="tdGrouping_Id" style="width:30px; text-align:center; display:none;"><#=objRow.Grouping_Id#></td>
                    <td class="GridViewLabItemStyle" id="tdServiceID" style="width:30px; text-align:center; display:none;"><#=objRow.ServiceID#></td>
                    <td class="GridViewLabItemStyle" id="tdComponentID" style="width:30px; text-align:center; display:none;"><#=objRow.ComponentID#></td>
                    <td class="GridViewLabItemStyle" style="width:30px; text-align:center;"><img id="imgSelect" src="../../Images/Post.gif" onclick="SetScreening(this);" title="Click To Set Screening" onmouseover="chngcur()" /></td>
                </tr>           
        <#}#>                     
     </table>    
    </script>

    <div id="divScreening" tabindex="-1" role="dialog" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color:white; width:700px">
                <div class="modal-header">
                    <button type="button" class="close btnClosePopup" data-dismiss="divScreening" area-hidden="true">&times;</button>
                    <h4 class="modal-title">Cross Match</h4>
                </div>
                <div class="modal-body">
                    <div class="row"><div class="col-md-24"><b><span id="spnMsgPop" style="color: Red;"></span>
                        <input type="hidden" id="CheckPatientExists" />
                                                            </b></div></div>
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
                                <span id="spnComponentID" style="display:none;"></span>
						  </div>
                    </div>
                    <div class="row">
                        <table cellspacing="0" rules="all" style="width:100%;border-right:#ffffff;">
                            <tr>
                                <td>
                                    Blood Bag No. :
                                </td>
                                <td>
                                    <select id="ddlbloodbagnum" style="width:250px;"></select>
                                    <input type="hidden" id="hfExpirydate" />
                                    <input type="hidden" id="hfStockID" />
                                    <input type="hidden" id="hfIsExists" />
                                    <input type="hidden" id="hfPatient_Name" />
                                </td>
                                <td>
                                    <input type="button" value="Add" title="click to add" id="btnAdd" disabled="disabled" onclick="AddDetails()" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                   
                                </td>
                            </tr>
                        </table>
                        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tblPatientData" style="width:100%;border-collapse:collapse;display:none;">
                            <thead>
                            <tr>
                                <th class="GridViewHeaderStyle">Component Name</th>
                                <th class="GridViewHeaderStyle">Blood Bag No.</th>
                                <th class="GridViewHeaderStyle">Blood Group</th>
                                <th class="GridViewHeaderStyle">Expiry date</th>
                                <th class="GridViewHeaderStyle">Cross Match</th>
                                <th class="GridViewHeaderStyle">Close</th>
                            </tr>
                                </thead>
                            <tbody></tbody>
                        </table>
                        <%--<table cellspacing="0" rules="all" border="1"  id="tb_ScreenDetail" style="width:100%;border-collapse:collapse;">
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
                                        <option value="0">1+</option>
                                        <option value="0">2+</option>
                                        <option value="0">3+</option>
                                        <option value="0">4+</option>
                                    </select>
                                </td>
                                <td>
                                    <select id="ddlCell2">
                                        <option value="0">0</option>
                                        <option value="0">1+</option>
                                        <option value="0">2+</option>
                                        <option value="0">3+</option>
                                        <option value="0">4+</option>
                                    </select>
                                </td>
                                <td>
                                    <select id="ddlCell3">
                                        <option value="0">0</option>
                                        <option value="0">1+</option>
                                        <option value="0">2+</option>
                                        <option value="0">3+</option>
                                        <option value="0">4+</option>
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
                                    <input type="text" id="txtRemarkCell1" maxlength="100" placeholder="Enter Remark Here" />
                                </td>
                            </tr>
                        </table>--%>
                    </div>
                </div>
                 <div class="modal-footer">
                         <button type="button" id="btnSaveScreening" disabled="disabled">Save</button>
                        <button type="button" id="btnUpdateCrossMatch" style="display:none;" onclick="UpdateCrossMatch();">Edit</button>
						 <button type="button"  data-dismiss="divScreening" class="btnClosePopup">Close</button>
				</div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function AddDetails() {
            var componentname = $("#spnComponent").text();
            var bagno = $("#ddlbloodbagnum option:selected").text().split('#')[0];
            var bloodgrup = $("#ddlbloodbagnum option:selected").text().split('#')[1];
            var expiry = $("#hfExpirydate").val();
            $("#tblPatientData tbody").empty();

            $("#tblPatientData tbody").append("<tr><td id='tdcomponentname'>" + componentname + "</td><td id='tdbagno'>" + bagno + "</td><td id='bloodgrup'>" + bloodgrup + "</td><td id='tdexpiry'>" + expiry + "</td><td><select id='ddlComp'><option value='0'>Select</option><option value='Compatible'>Compatible</option><option value='Not Compatible'>Not Compatible</option></select></td><td><img src='../../Images/Delete.gif' alt='close' id='btnClose' onclick='CloseTable()'></td></tr>")
            $("#tblPatientData").css("display", "");
            if ($('#divScreening #CheckPatientExists').text() == '1') {
                $('#divScreening #btnUpdateCrossMatch').css("display", "");
            }
            else {
                $("#btnSaveScreening").removeAttr("disabled");
            }

        }

        function CloseTable() {
            $("#tblPatientData tbody").empty();
            $("#tblPatientData").css("display", "none");
        }

        $("#ddlbloodbagnum").change(function () {
            var id = $(this).val();
            $("#tblPatientData tbody").empty();
            $("#tblPatientData").css("display", "none");
            var tube = $("#ddlbloodbagnum option:selected").text().split('#')[0];
            serverCall('PatientCrossMatching.aspx/GetExpiryDate', { ID: id, Tubeno: tube }, function (responce) {
              //  var data = JSON.parse(responce);
                var $responseData = JSON.parse(responce);
                //if (data != "") {
                //    $("#hfExpirydate").val(data);
                //    $("#btnAdd").removeAttr("disabled");
                //}
                $("#hfIsExists").val($responseData.IsExists);
                    $("#hfExpirydate").val($responseData.date);
                    $("#hfStockID").val($responseData.stockID);
                    $("#btnAdd").removeAttr("disabled");
                    $("#hfPatient_Name").val($responseData.patientName);

            });
        });

        $(".btnClosePopup").click(function () {
            $("#tblPatientData tbody").empty();
            $("#tblPatientData").css("display", "none");
            $("#btnSaveScreening").attr("disabled", true);
            $("#btnAdd").attr("disabled", true);
            $('#divScreening #btnUpdateCrossMatch').css("display", "none");
        });

        function UpdateCrossMatch() {
            if ($("#ddlComp option:selected").val() == "0") {
                modelAlert("Please select Compatible");
            }
            else {
                var comp = $("#ddlComp option:selected").val();
                var componentID = $("#divScreening #spnComponentID").text();
                var patientid = $("#divScreening #spnPatientID").text();
                var stockid = $("#hfStockID").val();
                var itemID = $("#divScreening #spnItemID").text();
                var isExists = $("#hfIsExists").val();
                var bbtubenum = $("#ddlbloodbagnum option:selected").text().split('#')[0];

                if (isExists > 0) {
                    modelAlert("Bag Number already exists");
                }
                else {
                    $.ajax({
                        url: 'PatientCrossMatching.aspx/UpdateBloodCrossmatch',
                        data: '{ItemId:"' + itemID + '",ComponentID:"' + componentID + '",Compatiblity:"' + comp + '",PatientID:"' + patientid + '", StockID:"' + stockid + '",BagNumber:"' + bbtubenum + '"}',
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        async: false,
                        type: "POST",
                    }).done(function (r) {
                        var res = JSON.parse(r.d);
                        if (res == "OK") {
                            modelAlert("Record Updated Successfully");
                            $("#tblPatientData tbody").empty();
                            $("#tblPatientData").css("display", "none");
                            $("#btnSaveScreening").attr("disabled", true);
                            $("#btnAdd").attr("disabled", true);
                            $('#divScreening').hide();
                            $("#btnUpdateCrossMatch").css("display", "none");
                        }
                        else {
                            modelAlert("Something went wrong. try again later!!!");
                            $("#tblPatientData tbody").empty();
                            $("#tblPatientData").css("display", "none");
                            $("#btnSaveScreening").attr("disabled", true);
                            $("#btnAdd").attr("disabled", true);
                            $('#divScreening').hide();
                            $("#btnUpdateCrossMatch").css("display", "none");
                        }
                    });
                }
            }
        }
        //$("#btnUpdateCrossMatch").click(function () {
            
        //});

        $("#btnSaveScreening").click(function () {
            if ($("#ddlComp option:selected").val() == "0") {
                modelAlert("Please select Compatible");
            }
            else {
                var itemID = $("#divScreening #spnItemID").text();
                var componentID = $("#divScreening #spnComponentID").text();
                var componentname = $("#tdcomponentname").text();
                var IpdNum = $("#divScreening #spnIPDNo").text();
                var patientid = $("#divScreening #spnPatientID").text();
                var stockid = $("#hfStockID").val();
                var bbtubenum = $("#ddlbloodbagnum option:selected").text().split('#')[0];
                var ledgertnx = $("#divScreening #spnLedgerTnxNo").text();
                var comp = $("#ddlComp option:selected").val();
                var isExists = $("#hfIsExists").val();
                var ServiceID = $("#tdServiceID").text();
                
                if (IpdNum == "") {
                    IpdNum = "0";
                }
                
                if (isExists > 0) {
                    modelAlert("Bag Number already exists");
                }
                else {
                    $.ajax({
                        url: 'PatientCrossMatching.aspx/SaveCrossBlood',
                        data: '{ItemId:"' + itemID + '",ComponentID:"' + componentID + '",ComponentName:"' + componentname + '",IPDNO:"' + IpdNum + '",PatientID:"' + patientid + '", StockID:"' + stockid + '", TubeNum:"' + bbtubenum + '", LedgerTnxNo:"' + ledgertnx + '", Compatible:"' + comp + '",ServiceID:"' + ServiceID + '"}',
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        async: false,
                        type: "POST",
                    }).done(function (r) {
                        var res = JSON.parse(r.d);
                        if (res == "NO") {
                            modelAlert("Something went wrong try again !!! ");
                        }
                        else {
                            modelAlert("Save Successfully");
                        }
                        
                        $("#tblPatientData tbody").empty();
                        $("#tblPatientData").css("display", "none");
                        $("#btnSaveScreening").attr("disabled", true);
                        $("#btnAdd").attr("disabled", true);
                        $('#divScreening').hide();
                    });
                }
            }
        });
    </script>
</asp:Content>

