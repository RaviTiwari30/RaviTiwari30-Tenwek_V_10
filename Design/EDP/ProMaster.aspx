<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ProMaster.aspx.cs" Inherits="Design_EDP_ProMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Search.js"> </script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script src="../../Scripts/json2.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Pro Master</b>&nbsp;<br />
            <span id="spnErrorMsg" class="ItDoseLblError"></span>
            <div style="text-align: center">
                <input id="rdoNew" type="radio" name="Con" value="New" checked="checked" />New
            <input id="rdoEdit" type="radio" name="Con" value="Edit" />Edit    
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div id="Save-body">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <input type="text" autocomplete="off" style="border-bottom-color: red; border-bottom-width: 2px" onlytext="50" maxlength="50" allowcharscode="40,41" id="txtName" style="text-transform: uppercase" maxlength="50" title="Enter PRO Name" />
                    </div>
                </div>
            </div>
            <div id="Update-body">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Status
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <input id="rdoActive" type="radio" name="ActiveCon" value="1" checked="checked" />Active
                        <input id="rdoDeActive" type="radio" name="ActiveCon" value="0" />DeActive  
                        <input id="rdoBoth" type="radio" name="ActiveCon" value="2" />Both 
                    </div>

                    <div class="col-md-2">
                        <label class="pull-left">
                            Pro Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <select id="ddlProName" style="border-bottom-color: red; border-bottom-width: 2px" title="Select Pro" onchange="bindMappedPRODoctor(this);">
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="button" id="btnEditPro" value="Edit" title="Click To Edit PRO Name and Active Status"  onclick="EditPro($('#ddlProName')[0]);"/>
                    </div>
                     <div class="col-md-2">
                        <label class="pull-left">
                            Refer Doctor
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-4">
                        <select id="ddlReferDoctor" style="border-bottom-color: red; border-bottom-width: 2px" title="Select Refer Doctor">
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="button" id="btnMap" value="Map" onclick="MapPROtoDoctor();" />
                    </div>
                </div>
</div>
            <div class="POuter_Box_Inventory" style="text-align: center" id="divNewProSave">
                    <input type="button" id="btnSave" value="Save New Pro" tabindex="5" class="ItDoseButton" />
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center" id="divMapProDoctor">

                    <table class="GridViewStyle"    rules="all" border="1" id="tb_grdLabSearch"
                            style="width:100%;  border-collapse: collapse; display: none;">
                            <tr id="Header">
                                <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">S.No.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">PRO Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Refer Doctor Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Remove
                                </th>
                            </tr>
                        </table>
                    <input type="button" id ="btnSaveMapPro" value="Save Mapped" class="ItDoseButton" onclick="SaveMappedPROtoDoctor();" />
                </div>
            <div class="POuter_Box_Inventory" style="text-align: center" id="divAlreadyMappedProDoctor">
                    <div id="PROOutput" style="max-height: 500px; overflow-x: auto;" title="Mapped PRO Doctor">
                    </div>
                    <input type="button" id="btnUpdate" value="Update Mapped Detail" class="ItDoseButton" />
            </div>
            </div>
    <script type="text/javascript">

        function chkActiveCon(rowid) {
            $("#spnErrorMsg").text('');
            var rdotdActive = $(rowid).closest('tr').find('#tdActive input[type=radio]:checked').val();
            var spnActive = $.trim($(rowid).closest('tr').find('#spnActive').html());
            if (rdotdActive != spnActive) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('1'));
            }
            else if (($.trim($(rowid).closest('tr').find('#spnPRONameCon').html()) == "1")) {
                $(rowid).closest('tr').css("background-color", "#FDE76D");
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
            }
            else {
                $.trim($(rowid).closest('tr').find('#spnActiveCon').html('0'));
                $(rowid).closest('tr').css("background-color", "transparent");
            }
        }
        function bindMappedPRODoctor(proid) {
            var ProID = proid.value;
            if (ProID == "0")
                $('#btnEditPro').prop('disabled', true);
            else
                $('#btnEditPro').prop('disabled', false);

            $.ajax({
                url: "services/EDP.asmx/bindMappedProDoctor",
                data: '{ProID:"' + ProID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        PROData = jQuery.parseJSON(result.d);
                        if (PROData != null) {
                            var output = $('#tb_PROSearch').parseTemplate(PROData);
                            $('#PROOutput').html(output);
                            $('#PROOutput').show();
                            $('#btnUpdate').show();
                            $('#divAlreadyMappedProDoctor').show();
                        }
                    }
                    else {
                        $('#PROOutput').html();
                        $('#PROOutput').hide();
                        $('#btnUpdate').hide();
                        $('#divAlreadyMappedProDoctor').hide();
                        modelAlert('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#PROOutput').html();
                    $('#PROOutput').hide();
                    modelAlert('Error');
                }
            });
        }



        $(function () {
            if ($("#rdoNew").is(':checked')) {
                $('#divNewProSave').show();
                $('#divMapProDoctor').hide();
                $('#divAlreadyMappedProDoctor').hide();
                $("#btnSave").show();
                $('#Save-body').show();
                $('#Update-body').hide();
            }
            if ($("#rdoEdit").is(':checked')) {
                $('#divNewProSave').hide();
                $('#divMapProDoctor').show();
                $('#divAlreadyMappedProDoctor').show();
                $("#btnSave").hide();
                $('#Save-body').hide();
                $('#Update-body').show();
                $('#btnUpdate').hide();
                LoadPRO();
                LoadReferDotor();
                $('#btnSaveMapPro').hide();
                $('#btnEditPro').prop('disabled', true);
            }

            $("#rdoNew").bind("click", function () {
                $('#divNewProSave').show();
                $('#divMapProDoctor').hide();
                $('#divAlreadyMappedProDoctor').hide();
                $("#btnSave").show();
                $(".trCondition").hide();
                $("#spnErrorMsg").text('');
                hideAllDetail();
                $('#Save-body').show();
                $('#Update-body').hide();
                $('#btnSaveMapPro').hide();
            });
            $("#rdoEdit").bind("click", function () {
                $('#divNewProSave').hide();
                $("#tb_grdLabSearch tr:not(:first)").remove();
                $('#divMapProDoctor').hide();
                $('#divAlreadyMappedProDoctor').hide();
                $("#btnSave").hide();
                $(".trCondition").show();
                $("#spnErrorMsg").text('');
                $('#Save-body').hide();
                $('#Update-body').show();
                LoadPRO();
                LoadReferDotor();
                $('#ddlProName').prop('disabled', false).chosen("destroy").chosen();
            });

            $("#btnSave").bind("click", function () {
                $("#spnErrorMsg").text('');
                $('#btnSave').attr('disabled', 'disabled');
                savePRO();
            });
        });

        function hideAllDetail() {
            $('#PROOutput').html('');
            $('#PROOutput,#btnUpdate').hide();
            $('#tb_grdLabSearch').hide();
        }

    </script>
    <script id="tb_PROSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdPROSearch"
    style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">PRO_ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Pro Name</th>       
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">RefDoc_ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Refer Doctor Name</th>                      
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Active</th>
		</tr>

        <#       
        var dataLength=PROData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;     
        for(var j=0;j<dataLength;j++)
        {       
        objRow = PROData[j];
        #>
                    <tr id="<#=j+1#>">                            
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="td_PROId"  style="width:40px;display:none" ><#=objRow.PRO_ID#></td>                  
                    <td class="GridViewLabItemStyle" id="td_PROName" style="width:200px;"><#=objRow.ProName#>
                       <span id="spnPROName" style="display:none" ><#=objRow.ProName#> </span>
                       <span id="spnPRONameCon"  style="display:none" /></td> 
                    <td class="GridViewLabItemStyle" id="td_ReferDoctorID"  style="width:40px;display:none" ><#=objRow.ReferDoctorID#></td>                  
                    <td class="GridViewLabItemStyle" id="td_ReferDocName" style="width:200px;"><#=objRow.name#>                                               
                    <td class="GridViewLabItemStyle" id="tdActive"  style="width:60px;">
                    <input type="radio" id="rdotdActive" name="tdActive_<#=j+1#>" value="1"
                      onclick="chkActiveCon(this)"    <#if(objRow.IsActive=="1"){#> 
                        checked="checked"  <#} #> />Yes                         
                         <input type="radio" id="rdotdDeActive" name="tdActive_<#=j+1#>" value="0"
                        onclick="chkActiveCon(this)" <#if(objRow.IsActive=="0"){#> 
                        checked="checked"  <#} #>  />No                                               
                        <span id="spnActive" style="display:none"><#=objRow.IsActive#></span>
                         <span id="spnActiveCon" style="display:none"   />
                    </td>
                    </tr>           
        <#}#>                     
     </table>    
    </script>
    <script type ="text/javascript">
        $(function () {
            $("#btnUpdate").bind("click", function () {
                $('#btnUpdate').attr('disabled', 'disabled');
                if (validateMappedPRODoctorUpdate() == true) {
                    var resultMappedPRODoctorUpdate = MappedPRODoctorUpdate();
                    $.ajax({
                        url: "Services/EDP.asmx/UpdateMappedPRODoctor",
                        data: JSON.stringify({ Data: resultMappedPRODoctorUpdate }),
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            if (result.d == "1") {
                                modelAlert('Record Update Successfully', function () {
                                    $('#btnUpdate').removeAttr('disabled');
                                    $('#PROOutput').html('');
                                    $('#PROOutput,#btnUpdate,.trCondition').hide();
                                    $('#rdoActive').prop('checked', 'checked');
                                    hideAllDetail();
                                    LoadPRO();
                                });
                            }
                            else if (result.d == "2") {
                                modelAlert('Pro Already Exist');
                                $('#btnUpdate').removeAttr('disabled');
                            }
                            else {
                            }

                        },
                        error: function (xhr, status) {
                            DisplayMsg('MM05', 'spnErrorMsg');
                        }
                    });
                }
                else {
                    $('#btnUpdate').removeProp('disabled');
                }
            });

        });
        function MappedPRODoctorUpdate() {
            if ($('#tb_grdPROSearch tr').length > 0) {
                var con = 0;
                var dataItem = new Array();
                var ObjItem = new Object();
                $("#tb_grdPROSearch tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "Header") {
                        ObjItem.PROID = $.trim($rowid.find("#td_PROId").text());
                        ObjItem.RefDocID = $.trim($rowid.find("#td_ReferDoctorID").text());
                        ObjItem.isActive = $.trim($rowid.find("#tdActive").find('input[type=radio]:checked').val());
                        dataItem.push(ObjItem);
                        ObjItem = new Object();
                    }
                });
                return dataItem;
            }
        }
        function validateMappedPRODoctorUpdate() {
            var tableCon = 1;
            $("#tb_grdPROSearch tr").each(function () {
                var id = $(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "Header") {
                    if ($.trim($rowid.find('#spnActiveCon').html()) == "1") {
                        tableCon += 1;
                    }
                }
            });
            if (tableCon == "1") {
                $("#spnErrorMsg").text('Please Change Pro Name OR Active Condition');
                return false;
            }
            return true;
        }
        function savePRO() {
            if (validatePRO() == true) {

                $.ajax({
                    url: "Services/EDP.asmx/SavePro",
                    data: '{ProName:"' + $.trim($('#txtName').val()) + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    cache: false,
                    success: function (result) {
                        if (result.d == "0") {
                            DisplayMsg('MM05', 'spnErrorMsg');
                        }
                        else if (result.d == "E") {
                            $("#spnErrorMsg").text('Pro Already Exist');
                            $('#txtName').focus();
                            $("#btnSave").removeProp('disabled');
                        }
                        else {
                            $("#spnErrorMsg").text('Record Saved Successfully');
                            $('#txtName').val('');
                            $("#btnSave").removeProp('disabled');
                        }
                    },
                    error: function (xhr, status) {
                        DisplayMsg('MM05', 'spnErrorMsg');
                    }
                });
            }
            else {
                $('#btnSave').removeProp('disabled');
            }
        }
        function validatePRO() {
            if ($.trim($('#txtName').val()) == "") {
                $("#spnErrorMsg").text('Please Enter Pro Name');
                $('#txtName').focus();
                return false;
            }
            return true;
        }
    </script>

        <script type="text/javascript">


            function EditPro(EditPRo) {
                $('#divEditPRO input[type=text]').val($('#ddlProName option:selected').text());
                $('#divEditPRO').showModel();
            }

            $("#rdoActive").bind("click", function () {
                LoadPRO();
            });
            $("#rdoDeActive").bind("click", function () {
                LoadPRO();
            });
            $("#rdoBoth").bind("click", function () {
                LoadPRO();
            });

            function LoadPRO() {
                var Type = "";
                if ($("#rdoActive").is(':checked'))
                    Type = "1";
                else if ($("#rdoDeActive").is(':checked'))
                    Type = "0";
                else
                    Type = "2";
                serverCall('services/EDP.asmx/bindPro', { Type: Type }, function (response) {
                    $ddlPRO = $('#ddlProName');
                    $ddlPRO.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Pro_ID', textField: 'ProName', isSearchAble: true });
                });
            }

            function LoadReferDotor() {
                serverCall('../Common/CommonService.asmx/bindReferDoctor', {PROID:'0'}, function (response) {
                    $ddlReferDoctor = $('#ddlReferDoctor');
                    $ddlReferDoctor.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                });
            }

            function MapPROtoDoctor() {

                $('#ddlProName').prop('disabled', true).chosen("destroy").chosen();
                var ProID = $('#ddlProName option:selected').val();
                var RefDoctorID = $('#ddlReferDoctor option:selected').val();
                var ProName = $('#ddlProName option:selected').text();
                var RefDocName = $('#ddlReferDoctor option:selected').text();

                if (ProID == "0") {
                    modelAlert('Please Select PRO !!');
                    $('#ddlProName').prop('disabled', false).chosen("destroy").chosen();
                    return false;
                }
                if (RefDoctorID == "0") {
                    modelAlert('Please Select Refer Doctor !!');
                    return false;
                }

                RowCount = $("#tb_grdLabSearch tr").length;
                RowCount = RowCount + 1;

                var AlreadySelect = 0;
                if (RowCount > 2) {
                    $("#tb_grdLabSearch tr").each(function () {
                        if ($(this).attr("id") == 'tr_' + RefDoctorID) {
                            AlreadySelect = 1;
                            return;
                        }
                    });
                }
                if (AlreadySelect == "0") {
                    var newRow = $('<tr />').attr('id', 'tr_' + RefDoctorID);
                    newRow.html('<td class="GridViewLabItemStyle" >' + (RowCount - 1) +
                         '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_PROId >' + ProID +
                         '</td><td class="GridViewLabItemStyle" style="text-align:center" id=td_PROName >' + ProName +
                         '</td><td  class="GridViewLabItemStyle" style="text-align:center" id=td_RefDocName >' + RefDocName +
                         '</td><td  class="GridViewLabItemStyle" style="display:none;" id=td_RefDocID >' + RefDoctorID +
                         '</td><td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);" title="Click To Remove" /></td>'
                        );
                    $("#tb_grdLabSearch").append(newRow);
                    $("#tb_grdLabSearch").show();
                    $('#btnSaveMapPro').show();
                    $('#divMapProDoctor').show();
                }
                else {
                    modelAlert('Refer Doctor Already Selected !!!');
                }
            }

            function DeleteRow(rowid) {
                var row = rowid;
                $(row).closest('tr').remove();
                RowCount = RowCount - 1;
                if ($("#tb_grdLabSearch tr").length == "1") {
                    $("#tb_grdLabSearch").hide();
                    $('#ddlProName').prop('disabled', false).chosen("destroy").chosen();
                    $('#btnSaveMapPro').hide();
                }
            }

            function SaveMappedPROtoDoctor() {
                var PROID = $('#ddlProName option:selected').val();
                if (PROID != "0") {
                    var dataLTDt = new Array();
                    var ObjLdgTnxDt = new Object();
                    jQuery("#tb_grdLabSearch tr").each(function () {
                        var id = jQuery(this).attr("id");
                        var $rowid = jQuery(this).closest("tr");
                        if (id != "Header") {
                            ObjLdgTnxDt.ProID = jQuery.trim($rowid.find("#td_PROId").text());
                            ObjLdgTnxDt.RefDocID = jQuery.trim($rowid.find("#td_RefDocID").text());
                            dataLTDt.push(ObjLdgTnxDt);
                            ObjLdgTnxDt = new Object();
                        }

                    });
                    if (dataLTDt.length > 0) {
                        $.ajax({
                            url: "Services/EDP.asmx/SaveMapPRoToDoctor",
                            data: JSON.stringify({ Data: dataLTDt }),
                            type: "POST", // data has to be Posted    	        
                            contentType: "application/json; charset=utf-8",
                            timeout: 120000,
                            dataType: "json",
                            async: false,
                            success: function (result) {
                                Data = result.d;
                                if (Data == "1") {
                                    $("#tb_grdLabSearch tr:not(:first)").remove();
                                    $("#tb_grdLabSearch").hide();
                                    modelAlert('Record Save Successfully', function () {
                                        $('#ddlProName').prop('disabled', false).chosen("destroy").chosen();
                                        bindMappedPRODoctor($('#ddlProName')[0]);
                                    });
                                }
                                else {
                                    modelAlert('Record Not Saved');
                                }
                            },
                            error: function (xhr, status) {

                            }
                        });
                    }
                }
            }

            function $UpdatePRoName(EditPRODetails) {
                if (EditPRODetails.Name.trim() == '') {
                    modelAlert('Enter PRO Name');
                    return false;
                }
                var EditProId = $('#ddlProName option:selected').val();
                serverCall('Services/EDP.asmx/UpdatePRODetail', { EditPROID: EditProId, Name: EditPRODetails.Name, Active: EditPRODetails.Active, DeActive: EditPRODetails.DeActivate }, function (response) {
                    $responseData = parseInt(response);
                    if ($responseData == '0')
                        modelAlert('PRO Already Exist');
                    else if ($responseData == '1') {
                        $('#divEditPRO').closeModel();
                        modelAlert('PRO Update Successfully', function (response) {
                            LoadPRO();
                            $('#divMapProDoctor').hide();
                            $('#divAlreadyMappedProDoctor').hide();
                        });
                    }
                    else
                        modelAlert('Error occurred, Please contact administrator');
                });


            }

        </script>

        <div id="divEditPRO"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:550px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divEditPRO" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Edit PRO</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						 <div class="col-md-6">
							   <label class="pull-left">Name   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div class="col-md-18">
							   <input type="text" autocomplete="off" style="border-bottom-color:red;border-bottom-width:2px" onlyText="50" maxlength="50" allowCharsCode="40,41"   id="txtEditPROName" style="text-transform:uppercase"   maxlength="50"  title="Enter PRO Name" />
						  </div>
					</div>
					<div class="row">
						  <div class="col-md-6">
							   <label class="pull-left">Active Staus   </label>
							   <b class="pull-right">:</b>
						  </div>
						  <div  class="col-md-18" >
							  <input id="rdoEditActive" type="radio" name="EditActive" value="1" checked="checked" />Active
                              <input id="rdoEditDeActive" type="radio" name="EditActive" value="0" />DeActive  
						  </div>
					</div>

				</div>
				  <div class="modal-footer">
						 <button type="button"  onclick="$UpdatePRoName({Name:$('#txtEditPROName').val(),Active:$('#rdoEditActive').val(),DeActivate:$('#rdoEditDeActive').val()})">Update</button>
						 <button type="button"  data-dismiss="divEditPRO" >Close</button>
				</div>
            </div>
			</div>
		</div>
	</div>
</asp:Content>

