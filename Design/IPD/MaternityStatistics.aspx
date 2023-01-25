<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="MaternityStatistics.aspx.cs" Inherits="Design_IPD_MaternityStatistics" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        th {
        font-size:smaller;
        }
        .POuter_Box_Inventory {
        
        width:1520px;
        }
    </style>
   
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    
    <link href="../../Styles/BedManagement.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/fusioncharts.js"></script>
    <script type="text/javascript" src="../../Scripts/fusioncharts.theme.fint.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            createGrid();
            bindMaternityStats();
            $('#<%=ddlMonth.ClientID %>').on('change', '', function (e) {
                bindMaternityStats();
            });
            $('#<%=ddlYear.ClientID %>').on('change', '', function (e) {
                bindMaternityStats();
            });
        });
        function Stats() {
            var dataStats = new Array();
            var ObjStats = new Object();
          
            jQuery("#tblData tr").each(function (index,obj) {
                var id = jQuery(this).attr("id");

               // var $rowid = jQuery(this).closest("tr");
                 var $rowid = jQuery(obj);
                //alert($rowid.find("input.btn").attr('id'));
                 var a=$rowid.find("input.btn").attr('id');
                 if (id != "header" && a!=undefined) {
                    if ($rowid.find("span.Total").text() != "" && $rowid.find("span.Total").text() != "0") {
                       
                        ObjStats.ID = $rowid.find("span.ID").text();
                        //alert($rowid.find("span.ID").text());
                        ObjStats.BtnId = $rowid.find("input.btn").attr('id');
                        ObjStats.Total = $rowid.find("span.Total").text();
                        ObjStats.CS = $rowid.find("span.CS").text();
                        ObjStats.SVD = $rowid.find("span.SVD").text();
                        ObjStats.BREEC = $rowid.find("span.BREEC").text();
                        ObjStats.AVD = $rowid.find("span.AVD").text();
                        ObjStats.LBIRTH = $rowid.find("span.LBIRTH").text();
                        ObjStats.FBIRTHFSB = $rowid.find("span.FBIRTHFSB").text();
                        ObjStats.SBIRTHFSB = $rowid.find("span.SBIRTHFSB").text();
                        ObjStats.SBIRTHMSB = $rowid.find("span.SBIRTHMSB").text();
                        ObjStats.KGS = $rowid.find("span.KGS").text();
                        ObjStats.PRETERM = $rowid.find("span.PRETERM").text();
                        ObjStats.ECLAMPSIA = $rowid.find("span.ECLAMPSIA").text();
                        ObjStats.RUTERUS = $rowid.find("span.RUTERUS").text();
                        ObjStats.OBSTLABC = $rowid.find("span.OBSTLABC").text();
                        ObjStats.APH = $rowid.find("span.APH").text();
                        ObjStats.PPH = $rowid.find("span.PPH").text();
                        ObjStats.SEPSIS = $rowid.find("span.SEPSIS").text();
                        ObjStats.MILD = $rowid.find("span.MILD").text();
                        ObjStats.MODERA = $rowid.find("span.MODERA").text();
                        ObjStats.SERVER = $rowid.find("span.SERVER").text();
                        ObjStats.YEAR18 = $rowid.find("span.YEAR18").text();
                        ObjStats.YEAR1824 = $rowid.find("span.YEAR1824").text();
                        ObjStats.YEAR24 = $rowid.find("span.YEAR24").text();
                        ObjStats.ONETEAR = $rowid.find("span.ONETEAR").text();
                        ObjStats.TWOTEAR = $rowid.find("span.TWOTEAR").text();
                        ObjStats.THREETEAR = $rowid.find("span.THREETEAR").text();
                        ObjStats.FOURTEAR = $rowid.find("span.FOURTEAR").text();
                        ObjStats.EPISIOTOMY = $rowid.find("span.EPISIOTOMY").text();
                        ObjStats.NEWBORNRESUSCITATION = $rowid.find("span.NEWBORNRESUSCITATION").text();

                        if ($rowid.find("span.Total").text() != "" && $rowid.find("span.Total").text() != "0") {
                            dataStats.push(ObjStats);
                            ObjStats = new Object();
                        }
                    }
                       
                    
                }

            });
            return dataStats;
        }
        function saveStats() {
            $(".edit").hide();

            //$("#btn" + id).closest('tr').find("span").hide();
            //$("#btn" + id).closest('tr').find("input.edit").show();
            //alert(id);
            var lastid = localStorage.getItem("lastid");

            $("#btn" + lastid).closest('tr').find("td").each(function (index, obj) {
                if ($(obj).find("input").val() != "Edit") {
                    $(obj).find("span").text($(obj).find("input").val());
                    $(obj).find("span").show();
                    $(obj).find("input").hide();
                }
            });
            getTotal(lastid);
            var resultStats = Stats();
            var month = $('#<%=ddlMonth.ClientID %>').val();
            var year = $('#<%=ddlYear.ClientID %>').val();
            if (resultStats != "") {
                $.ajax({
                    type: "POST",
                    data: JSON.stringify({ stats1: resultStats, month: month, year: year }),
                    url: "MaternityStatistics.aspx/saveStats",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        modelAlert("Saved Successfully", function () {
                            // alert();
                            location.reload();
                        });
                        
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                        $('#btnSave').removeProp('disabled');
                    }

                });
            }
            else
                $("#lblMsg").text('Please Select At Least One CheckBox');

        }

        function bindMaternityStats() {
            var mnth = $('#<%=ddlMonth.ClientID %>').val();
            var yr = $('#<%=ddlYear.ClientID %>').val();
            jQuery.ajax({
                type: "POST",
                url: "MaternityStatistics.aspx/bindMaternityStats",
                data: '{month:"' + mnth + '",year:"' + yr + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                success: function (response) {
                    Newitem = jQuery.parseJSON(response.d);
                    //$("#tblData > tbody").html('');
                    $('#tblData  > tbody > tr').not(':first').remove();
                    createGrid();
                    if (Newitem != null) {
                        var head = "";
                        //$("#tblData").find("tr.row").remove();
                        var sumTotal = 0;
                        var sumCS = 0;
                        var sumSVD = 0;
                        var sumBREEC = 0;
                        var sumAVD = 0;
                        var sumLBIRTH = 0;
                        var sumFBIRTHFSB = 0;
                        var sumSBIRTHFSB = 0;
                        var sumSBIRTHMSB = 0;
                        var sumKGS = 0;
                        var sumPRETERM = 0;
                        var sumECLAMPSIA = 0;
                        var sumRUTERUS = 0;
                        var sumOBSTLABC = 0;
                        var sumAPH = 0;
                        var sumPPH = 0;
                        var sumSEPSIS = 0;
                        var sumMILD = 0;
                        var sumMODERA = 0;
                        var sumSERVER = 0;
                        var sumYEAR18 = 0;
                        var sumYEAR1824 = 0;
                        var sumYEAR24 = 0;
                        var sumONETEAR = 0;
                        var sumTWOTEAR = 0;
                        var sumTHREETEAR = 0;
                        var sumFOURTEAR = 0;
                        var sumEPISIOTOMY = 0;
                        var sumNEWBORNRESUSCITATION = 0;
                        $.each(Newitem, function (index, obj) {

                            //if ($('#tr' + obj["ID"]).length)
                            {
                                /* it exists */
                                var row = '';
                                var i = 0;
                                if (obj["BtnId"].length == 5) {
                                    i = obj["BtnId"].substr(3, 1);
                                    
                                }
                                else {
                                    i = obj["BtnId"].substr(3, 2);
                                }
                                if (obj["BtnId"].substr(obj["BtnId"].length-1 , 1) == "1") {
                                    row += '<td class="GridViewLabItemStyle"   ><span id="span' + obj["ID"] + '" class="ID" style="display:none;" >' + obj["ID"] + '</span><input type="button" class="btn" value="Edit" id="btn' + i + '1" onclick="edit(' + i + '1);" /><input type="button" class="btnSave" value="Save" style="display:none;" id="btnSave' + i + '1" onclick="saveTemp(' + i + '1);" /></td>';
                                    row += '<td class="GridViewLabItemStyle"  style="width:200px;"  >' + i + '</td>';
                                }
                                else {
                                    row += '<td class="GridViewLabItemStyle"   ><span id="span' + obj["ID"] + '" class="ID"  style="display:none;" >' + obj["ID"] + '</span><input type="button"  class="btn"  value="Edit" id="btn' + i + '2" onclick="edit(' + i + '2);" /><input type="button" class="btnSave" value="Save" style="display:none;" id="btnSave' + i + '2" onclick="saveTemp(' + i + '2);" /></td>';
                                    row += '<td class="GridViewLabItemStyle" style="width:200px;" >' + i + ' to ' + (parseInt(i) + 1) + '</td>';

                                }
                                
                                var validate = ' onkeypress="if ( isNaN( String.fromCharCode(event.keyCode) )) return false;" ';
                               
                              //  alert(obj["BtnId"]);
                                row += '<td class="GridViewLabItemStyle"  ><span class="Total">' + obj["Total"] + '</span><input type="text" class="edit" style="display:none;" '+validate+' value="' + obj["Total"] + '" /></td>';

                                row += '<td class="GridViewLabItemStyle"  ><span class="CS">' + obj["CS"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["CS"] + '" /></td>';
                                row += '<td class="GridViewLabItemStyle"  ><span class="SVD">' + obj["SVD"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["SVD"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="BREEC">' + obj["BREEC"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["BREEC"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="AVD">' + obj["AVD"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["AVD"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="LBIRTH">' + obj["LBIRTH"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["LBIRTH"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="FBIRTHFSB">' + obj["FBIRTHFSB"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["FBIRTHFSB"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="SBIRTHFSB">' + obj["SBIRTHFSB"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["SBIRTHFSB"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="SBIRTHMSB">' + obj["SBIRTHMSB"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["SBIRTHMSB"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="KGS">' + obj["KGS"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["KGS"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="PRETERM">' + obj["PRETERM"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["PRETERM"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="ECLAMPSIA">' + obj["ECLAMPSIA"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["ECLAMPSIA"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="RUTERUS">' + obj["RUTERUS"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["RUTERUS"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="OBSTLABC">' + obj["OBSTLABC"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["OBSTLABC"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="APH">' + obj["APH"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["APH"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="PPH">' + obj["PPH"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["PPH"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="SEPSIS">' + obj["SEPSIS"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["SEPSIS"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="MILD">' + obj["MILD"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["MILD"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="MODERA">' + obj["MODERA"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["MODERA"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="SERVER">' + obj["SERVER"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["SERVER"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="YEAR18">' + obj["18YEAR"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["18YEAR"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="YEAR1824">' + obj["1824YEAR"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["1824YEAR"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="YEAR24">' + obj["24YEAR"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["24YEAR"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="ONETEAR">' + obj["ONETEAR"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["ONETEAR"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="TWOTEAR">' + obj["TWOTEAR"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["TWOTEAR"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="THREETEAR">' + obj["THREETEAR"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["THREETEAR"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="FOURTEAR">' + obj["FOURTEAR"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["FOURTEAR"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="EPISIOTOMY">' + obj["EPISIOTOMY"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["EPISIOTOMY"] + '" /></td>';
                                row += '<td  class="GridViewLabItemStyle" ><span class="NEWBORNRESUSCITATION">' + obj["NEWBORNRESUSCITATION"] + '</span><input type="text" class="edit" style="display:none;" ' + validate + '  value="' + obj["NEWBORNRESUSCITATION"] + '" /></td>';
                                //alert("#" + obj["BtnId"] + "");
                                if (parseInt(obj["Total"]) != NaN && obj["Total"] != "") {
                                    sumTotal += parseInt(obj["Total"]);
                                    //alert(obj["Total"]);
                                }
                                if (parseInt(obj["CS"]) != NaN && obj["CS"] != "") {
                                    sumCS += parseInt(obj["CS"]);
                                }
                                
                                if (parseInt(obj["SVD"]) != NaN && obj["SVD"] != "") {
                                    sumSVD += parseInt(obj["SVD"]);
                                }
                                if (parseInt(obj["BREEC"]) != NaN && obj["BREEC"] != "") {

                                    sumBREEC += parseInt(obj["BREEC"]);
                                }
                                if (parseInt(obj["AVD"]) != NaN && obj["AVD"] != "") {

                                    sumAVD += parseInt(obj["AVD"]);
                                }
                                if (parseInt(obj["LBIRTH"]) != NaN && obj["LBIRTH"] != "") {

                                    sumLBIRTH += parseInt(obj["LBIRTH"]);
                                }
                                if (parseInt(obj["FBIRTHFSB"]) != NaN && obj["FBIRTHFSB"] != "") {

                                    sumFBIRTHFSB += parseInt(obj["FBIRTHFSB"]);
                                }
                                if (parseInt(obj["SBIRTHFSB"]) != NaN && obj["SBIRTHFSB"] != "") {

                                    sumSBIRTHFSB += parseInt(obj["SBIRTHFSB"]);
                                }
                                if (parseInt(obj["SBIRTHMSB"]) != NaN && obj["SBIRTHMSB"] != "") {

                                    sumSBIRTHMSB += parseInt(obj["SBIRTHMSB"]);
                                }                               
                                if (parseInt(obj["KGS"]) != NaN && obj["KGS"] != "") {

                                    sumKGS += parseInt(obj["KGS"]);
                                }
                                if (parseInt(obj["PRETERM"]) != NaN && obj["PRETERM"] != "") {

                                    sumPRETERM += parseInt(obj["PRETERM"]);
                                }
                                if (parseInt(obj["ECLAMPSIA"]) != NaN && obj["ECLAMPSIA"] != "") {

                                    sumECLAMPSIA += parseInt(obj["ECLAMPSIA"]);
                                }
                                if (parseInt(obj["RUTERUS"]) != NaN && obj["RUTERUS"] != "") {

                                    sumRUTERUS += parseInt(obj["RUTERUS"]);
                                }
                                if (parseInt(obj["OBSTLABC"]) != NaN && obj["OBSTLABC"] != "") {

                                    sumOBSTLABC += parseInt(obj["OBSTLABC"]);
                                }
                                if (parseInt(obj["APH"]) != NaN && obj["APH"] != "") {

                                    sumAPH += parseInt(obj["APH"]);
                                }
                                if (parseInt(obj["PPH"]) != NaN && obj["PPH"] != "") {

                                    sumPPH += parseInt(obj["PPH"]);
                                }
                                if (parseInt(obj["SEPSIS"]) != NaN && obj["SEPSIS"] != "") {

                                    sumSEPSIS += parseInt(obj["SEPSIS"]);
                                }
                                if (parseInt(obj["MILD"]) != NaN && obj["MILD"] != "") {

                                    sumMILD += parseInt(obj["MILD"]);
                                }
                                if (parseInt(obj["MODERA"]) != NaN && obj["MODERA"] != "") {

                                    sumMODERA += parseInt(obj["MODERA"]);
                                }
                                if (parseInt(obj["SERVER"]) != NaN && obj["SERVER"] != "") {

                                    sumSERVER += parseInt(obj["SERVER"]);
                                }
                                if (parseInt(obj["18YEAR"]) != NaN && obj["18YEAR"] != "") {

                                    sumYEAR18 += parseInt(obj["18YEAR"]);
                                }
                                if (parseInt(obj["1824YEAR"]) != NaN && obj["1824YEAR"] != "") {

                                    sumYEAR1824 += parseInt(obj["1824YEAR"]);
                                }
                                if (parseInt(obj["24YEAR"]) != NaN && obj["24YEAR"] != "") {

                                    sumYEAR24 += parseInt(obj["24YEAR"]);
                                }
                                if (parseInt(obj["ONETEAR"]) != NaN && obj["ONETEAR"] != "") {

                                    sumONETEAR += parseInt(obj["ONETEAR"]);
                                }
                                if (parseInt(obj["TWOTEAR"]) != NaN && obj["TWOTEAR"] != "") {

                                    sumTWOTEAR += parseInt(obj["TWOTEAR"]);
                                }
                                if (parseInt(obj["THREETEAR"]) != NaN && obj["THREETEAR"] != "") {

                                    sumTHREETEAR += parseInt(obj["THREETEAR"]);
                                }
                                if (parseInt(obj["FOURTEAR"]) != NaN && obj["FOURTEAR"] != "") {

                                    sumFOURTEAR += parseInt(obj["FOURTEAR"]);
                                }
                                if (parseInt(obj["EPISIOTOMY"]) != NaN && obj["EPISIOTOMY"] != "") {

                                    sumEPISIOTOMY += parseInt(obj["EPISIOTOMY"]);
                                }
                                if (parseInt(obj["NEWBORNRESUSCITATION"]) != NaN && obj["NEWBORNRESUSCITATION"] != "") {

                                    sumNEWBORNRESUSCITATION += parseInt(obj["NEWBORNRESUSCITATION"]);
                                }
                                $("#" + obj["BtnId"] + "").closest('tr').html(row);

                              
                            }
                            //else {

                            //}
                        });

                        var row = '';

                        var edit1 = '<td class="GridViewLabItemStyle"   ></td>';
                        var edit2 = '<td class="GridViewLabItemStyle"   ></td>';
                        var td1 = '<td class="GridViewLabItemStyle" style="width:200px;" ></td>';
                        var td0 = '<td class="GridViewLabItemStyle"  style="width:200px;"  >TOTAL</td>';
                        row += '<td class="GridViewLabItemStyle"  ><span class="Total">'+sumTotal+'</span><input type="text" class="edit" style="display:none;" value=""  /></td>';
                        row += '<td class="GridViewLabItemStyle"  ><span class="CS">'+sumCS+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td class="GridViewLabItemStyle"  ><span class="SVD">'+sumSVD+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="BREEC">'+sumBREEC+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="AVD">'+sumAVD+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="LBIRTH">'+sumLBIRTH+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="FBIRTHFSB">'+sumFBIRTHFSB+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="SBIRTHFSB">'+sumSBIRTHFSB+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="SBIRTHMSB">'+sumSBIRTHMSB+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="KGS">'+sumKGS+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="PRETERM">'+sumPRETERM+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="ECLAMPSIA">'+sumECLAMPSIA+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="RUTERUS">'+sumRUTERUS+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="OBSTLABC">'+sumOBSTLABC+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="APH">'+sumAPH+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="PPH">'+sumPPH+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="SEPSIS">'+sumSEPSIS+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="MILD">'+sumMILD+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="MODERA">'+sumMODERA+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="SERVER">'+sumSERVER+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="YEAR18">'+sumYEAR18+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="YEAR1824">'+sumYEAR1824+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="YEAR24">'+sumYEAR24+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="ONETEAR">'+sumONETEAR+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="TWOTEAR">'+sumTWOTEAR+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="THREETEAR">'+sumTHREETEAR+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="FOURTEAR">'+sumFOURTEAR +'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="EPISIOTOMY">'+sumEPISIOTOMY+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        row += '<td  class="GridViewLabItemStyle" ><span class="NEWBORNRESUSCITATION">'+sumNEWBORNRESUSCITATION+'</span><input type="text" class="edit" style="display:none;" value="" /></td>';
                        $('#tblData tr:last').remove();

                        $("#tblData").append('<tr class="row" >' + edit1 + td0 + row + '</tr>');

                    }

                    else {

                    }
                    
                },
                error: function (xhr, status) {

                }
            });
        }
        function getTotal(id) {
            var total = 0;
            var elmtotal;
            $("#btn" + id).closest('tr').find("td").each(function (index, obj) {
              
                if (index !='2' && $(obj).find("input").val() != "Edit" && $(obj).find("input").val() != "Save" && $(obj).find("input").val() != "" && $(obj).find("input").val() != undefined) {
                    var x = parseInt($(obj).find("input").val());
                    if (x != NaN && x != undefined && $(obj).find("input").val()!='') {
                      
                        total += x;
                    }
                   // elmtotal = obj;
                }
            });
            $("#btn" + id).closest('tr').find("span.Total").text(total);

        }

        function edit(id)
        {
           
            $(".edit").hide();

            $("#btn" + id).closest('tr').find("span").hide();
            $("#btn" + id).closest('tr').find("input.edit").show();
            //alert(id);
            var lastid = localStorage.getItem("lastid");
            
            $("#btn" + lastid).closest('tr').find("td").each(function (index, obj) {
                if ($(obj).find("input").val() != "Edit") {
                    $(obj).find("span").text($(obj).find("input").val());
                    $(obj).find("span").show();
                }
            });
            getTotal(lastid);
            localStorage.setItem("lastid", id);

        }
        function getGrandTotal()
        {
            var grandtotal = 0;
            jQuery("#tblData tr").each(function () {
                var id = jQuery(this).attr("id");

                var $rowid = jQuery(this).closest("tr");

                if (id != "header" || (id != "undefined") || (id != "")) {
                    var elm= $rowid.find("span.Total").text();
                    if ( elm != "" && elm != undefined)
                    if ( elm!= "") {
                        grandtotal += parseInt($rowid.find("span.Total").text());
                    }
                }
            });

        }
        function saveTemp(id) {
            //alert(id);
            $(".edit").hide();
            $("#btn" + id).closest('tr').find("td").each(function (index, obj) {
                if ($(obj).find("input").val() != "Edit") {
                    $(obj).find("span").text($(obj).find("input").val());
                    $(obj).find("span").show();
                }
            });
        }

        function createGrid()
        {
            for (var i = 1; i <= 30; i++) {
                var validate = ' onkeypress="if ( isNaN( String.fromCharCode(event.keyCode) )) return false;" ';
                var row = '';
                var edit1 = '<td class="GridViewLabItemStyle"   ><input type="button" class="btn" value="Edit" id="btn' + i + '1" onclick="edit(' + i + '1);" /><input type="button" class="btnSave" value="Save" style="display:none;" id="btnSave' + i + '1" onclick="saveTemp(' + i + '1);" /></td>';
                var edit2 = '<td class="GridViewLabItemStyle"   ><input type="button"  class="btn"  value="Edit" id="btn' + i + '2" onclick="edit(' + i + '2);" /><input type="button" class="btnSave" value="Save" style="display:none;" id="btnSave' + i + '2" onclick="saveTemp(' + i + '2);" /></td>';
                var td1 = '<td class="GridViewLabItemStyle" style="width:200px;" >' + i + ' to ' + (i + 1) + '</td>';
                var td0 = '<td class="GridViewLabItemStyle"  style="width:200px;"  >' + i + '</td>';

                var validate = ' onkeypress="if ( isNaN( String.fromCharCode(event.keyCode) )) return false;" ';
                row += '<td class="GridViewLabItemStyle"  ><span class="Total"></span><input type="text" class="edit" style="display:none;" '+validate+' value="" '+validate+' /></td>';
                row += '<td class="GridViewLabItemStyle"  ><span class="CS"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td class="GridViewLabItemStyle"  ><span class="SVD"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="BREEC"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="AVD"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="LBIRTH"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="FBIRTHFSB"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="SBIRTHFSB"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="SBIRTHMSB"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="KGS"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="PRETERM"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="ECLAMPSIA"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="RUTERUS"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="OBSTLABC"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="APH"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="PPH"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="SEPSIS"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="MILD"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="MODERA"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="SERVER"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="YEAR18"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="YEAR1824"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="YEAR24"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="ONETEAR"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="TWOTEAR"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="THREETEAR"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="FOURTEAR"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="EPISIOTOMY"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';
                row += '<td  class="GridViewLabItemStyle" ><span class="NEWBORNRESUSCITATION"></span><input type="text" class="edit" style="display:none;" ' + validate + '  value="" /></td>';

                $("#tblData").append('<tr class="row" >' +edit1+ td0 + row + '</tr>');
                $("#tblData").append('<tr class="row" >' + edit2 + td1 + row + '</tr>');
            }
            var row = '';
            var edit1 = '<td class="GridViewLabItemStyle"   ></td>';
            var edit2 = '<td class="GridViewLabItemStyle"   ></td>';
            var td0 = '<td class="GridViewLabItemStyle"  style="width:200px;"  >TOTAL</td>';
            row += '<td class="GridViewLabItemStyle"  ><span class="Total"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td class="GridViewLabItemStyle"  ><span class="CS"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td class="GridViewLabItemStyle"  ><span class="SVD"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="BREEC"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="AVD"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="LBIRTH"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="FBIRTHFSB"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="SBIRTHFSB"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="SBIRTHMSB"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="KGS"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="PRETERM"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="ECLAMPSIA"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="RUTERUS"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="OBSTLABC"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="APH"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="PPH"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="SEPSIS"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="MILD"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="MODERA"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="SERVER"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="YEAR18"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="YEAR1824"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="YEAR24"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="ONETEAR"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="TWOTEAR"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="THREETEAR"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="FOURTEAR"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="EPISIOTOMY"></span><input type="text" class="edit" style="display:none;" value="" /></td>';
            row += '<td  class="GridViewLabItemStyle" ><span class="NEWBORNRESUSCITATION"></span><input type="text" class="edit" style="display:none;" value="" /></td>';

            $("#tblData").append('<tr class="row" >' + edit1 + td0 + row + '</tr>');

        }

    </script>
    <div id="Pbody_box_inventory" style="width: 1525px;">

        <cc1:ToolkitScriptManager runat="server" ID="scCustom"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="">
            <div class="content" style="">
                <div style="text-align: center">
                    <b>Maternity Statistics</b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
                </div>
            </div>
             
        </div>
        <div class="POuter_Box_Inventory" >
             <div class="row">
                <div class="col-md-2">Month</div>
                <div class="col-md-2">
                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="ddlFilter">
                        <asp:ListItem Value="0" Text="Select" />
                        <asp:ListItem Value="1" Text="Jan" />
                        <asp:ListItem Value="2" Text="Feb" />
                        <asp:ListItem Value="3" Text="Mar" />
                        <asp:ListItem Value="4" Text="April" />
                        <asp:ListItem Value="5" Text="May" />
                        <asp:ListItem Value="6" Text="June" />
                        <asp:ListItem Value="7" Text="July" />
                        <asp:ListItem Value="8" Text="Aug" />
                        <asp:ListItem Value="9" Text="Sept" />
                        <asp:ListItem Value="10" Text="Oct" />
                        <asp:ListItem Value="11" Text="Nov" />
                        <asp:ListItem Value="12" Text="Dec" />
                    </asp:DropDownList>
                    <%--<select id="selectMonth">
                        <option value="0">--Select--</option>
                        <option value="1">Jan</option>
                        <option value="2">Feb</option>
                        <option value="3">Mar</option>
                        <option value="4">April</option>
                        <option value="5">May</option>
                        <option value="6">June</option>
                        <option value="7">July</option>
                        <option value="8">Aug</option>
                        <option value="9">Sept</option>
                        <option value="10">Oct</option>
                        <option value="11">Nov</option>
                        <option value="12">Dec</option>
                    </select>--%>
                    </div>
                 
                <div class="col-md-2">Year</div>
                <div class="col-md-2">
                     <asp:DropDownList ID="ddlYear" runat="server" >
                        <asp:ListItem Value="0" Text="Select" />
                        <asp:ListItem Value="2022" Text="2022" />
                        <asp:ListItem Value="2021" Text="2021" />
                        <asp:ListItem Value="2020" Text="2020" />
                        <asp:ListItem Value="2019" Text="2019" />
                        <asp:ListItem Value="2018" Text="2018" />
                        <asp:ListItem Value="2017" Text="2017" />
                        <asp:ListItem Value="2016" Text="2016" />
                        <asp:ListItem Value="2015" Text="2015" />
                        <asp:ListItem Value="2014" Text="2014" />
                        <asp:ListItem Value="2013" Text="2013" />
                        <asp:ListItem Value="2012" Text="2012" />
                        <asp:ListItem Value="2011" Text="2011" />
                    </asp:DropDownList>
                   <%-- <select id="selectYear">
                        <option value="0">--Select--</option>
                        <option value="2021">2021</option>
                        <option value="2020">2020</option>
                        <option value="2019">2019</option>
                        <option value="2018">2018</option>
                        <option value="2017">2017</option>
                        <option value="2016">2016</option>
                        <option value="2015">2015</option>
                        <option value="2014">2014</option>
                        <option value="2013">2013</option>
                        <option value="2012">2012</option>
                        <option value="2011">2011</option>
                        <option value="2010">2010</option>
                    </select>--%>
                    </div>
                   <div class="col-md-2">
                       <input type="button" value="Search" />
                       </div>
                   <div class="col-md-2">
                       <input type="button" value="Save" onclick="saveStats();" />
                       </div>
                  </div>
            <div class="row">
                <div class="col-md-24">
                    <div style="overflow-x:auto;">
                    <table id="tblData" style="width:100%;">
                        <tr id="header" class="row">
                            
                            <th class="GridViewHeaderStyle" style="width:300px;"></th>
                            <th class="GridViewHeaderStyle" style="width:300px;"></th>
                            <th class="GridViewHeaderStyle">Total</th>
                            <th class="GridViewHeaderStyle">C/S</th>
                            <th class="GridViewHeaderStyle">SVD</th>
                            <th class="GridViewHeaderStyle">BREEC</th>
                            <th class="GridViewHeaderStyle">AVD</th>
                            <th class="GridViewHeaderStyle">L.BIRTH</th>
                            <th class="GridViewHeaderStyle">F.BIRTHFSB</th>
                            <th class="GridViewHeaderStyle">S.BIRTH FSB</th>
                            <th class="GridViewHeaderStyle">S.BIRTH MSB</th>
                            <th class="GridViewHeaderStyle"><2.5 KGS</th>
                            <th class="GridViewHeaderStyle">PRETERM</th>
                            <th class="GridViewHeaderStyle">ECLAMPSIA</th>
                            <th class="GridViewHeaderStyle">R.UTERUS</th>
                            <th class="GridViewHeaderStyle">OBST.LABC</th>
                            <th class="GridViewHeaderStyle">APH</th>
                             <th class="GridViewHeaderStyle">PPH</th> 
                            <th class="GridViewHeaderStyle">SEPSIS</th>
                             <th class="GridViewHeaderStyle">MILD</th>
                             <th class="GridViewHeaderStyle">MODERA</th>
                             <th class="GridViewHeaderStyle">SERVER</th>
                             <th class="GridViewHeaderStyle"><18 YEAR</th>
                             <th class="GridViewHeaderStyle">18-24 YEAR</th>
                             <th class="GridViewHeaderStyle">>24 YEAR</th>
                             <th class="GridViewHeaderStyle">1 &deg; TEAR</th>
                             <th class="GridViewHeaderStyle">2 &deg; TEAR</th>
                             <th class="GridViewHeaderStyle">3 &deg; TEAR</th>
                             <th class="GridViewHeaderStyle">4 &deg; TEAR</th>
                             <th class="GridViewHeaderStyle">EPISIOTOMY</th>
                             <th class="GridViewHeaderStyle">NEW BORN RESUSCITATION</th>
                            
                  </tr>
                    </table>
                        </div>
                </div>
            </div>
       </div>

    
</asp:Content>
