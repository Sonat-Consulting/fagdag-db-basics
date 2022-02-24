create table game_state (state int);

create or replace procedure usp_Battle1()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE '---------- Step 1 -----------' ;
        RAISE NOTICE '-- Unwanted null values -----';
        RAISE NOTICE 'Future-Christian: Hello!';
        RAISE NOTICE 'Future-Christian: I am trying to add a new person to the person table.';
        RAISE NOTICE 'I do not know his last name.  I assume it doesnt matter.';
        RAISE NOTICE ' ';
        RAISE NOTICE 'Narrator: It does.';

        BEGIN
            INSERT INTO person values(3250003, 123456789101112, 4000, 'F',   'Martin',  Null);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Future-Christian: Hmmm.. That did not work.';
                RAISE NOTICE 'Narrator: Future-Christian fails to fill the database with nameless people.  Step completed.';
                INSERT INTO game_state values (1);
                RETURN;
         END;

        RAISE NOTICE 'Narrator: Future-Christian succeeds in filling the database with nameless people.   Try to stop him.';
        ROLLBACK;

    end$$;


create or replace procedure usp_Battle2()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE '---------- Step 2 -----------' ;
        RAISE NOTICE '-- Missing foreign key  -----';

        RAISE NOTICE 'Future-Christian: I was thinking to add my city, "Slopergrad". ';
        RAISE NOTICE 'Future-Christian: I do not have a country code for it, so I will add XXX for that';
        RAISE NOTICE ' ';
        RAISE NOTICE 'Narrator:  This is problematic.  We have reports that depend on joining city and country.';

        BEGIN
            INSERT INTO city values (9999,'Slopergrad','XXX','District9',1);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Future-Christian: Uff.. That was not possible either.';
                RAISE NOTICE 'Narrator: Future-Christian must now find country codes to add his cities. The base remains consistent.';
                RAISE NOTICE 'Step completed.';
                INSERT INTO game_state values (2);
                RETURN;
        END;

        RAISE NOTICE 'Narrator: Future-Christian succeeds adding cities with no countries.';
        RAISE NOTICE 'This is problematic when we compare population/country vs. total population.';
        RAISE NOTICE 'Try to add a requirement that all cities has to be in a country.';
        ROLLBACK;


    end$$;



create or replace procedure usp_Battle3()
LANGUAGE plpgsql
AS $$
    BEGIN

        RAISE NOTICE '---------Step 3----------------';
        RAISE NOTICE '--- Duplicate logical key -----';
        RAISE NOTICE 'Future-Christian: I am adding a new person.  I am not sure I remember his world_sec_nr. Maybe I made a mistake here.';
        RAISE NOTICE ' ';
        RAISE NOTICE 'Narrator: If he uses the world_sec_nr of an existing person we will have big problems when the back-end queries us!';
        BEGIN
            INSERT INTO person values(3250001, 8983027730798, 4000, 'M',   'Martin',  'Sloper');
            RAISE NOTICE 'Narrator: Future-Christian adds a new person, but he uses an existing world_sec_nr. This should have been a logical key. Nrgh!';
        EXCEPTION
                WHEN OTHERS THEN
                    RAISE NOTICE 'Future-Christian: Ack... That did not work either.';
                    RAISE NOTICE ' ';
                    RAISE NOTICE 'Narrator: Future-Christian has been stopped and we can still answer the backend when it queries us.';
                    RAISE NOTICE 'Step completed.';
                    INSERT INTO game_state values (3);
                RETURN;
        END;
        RAISE NOTICE 'Narrator:  Future-Christian succeeds.  We can no longer uniquely identify a person when the back end queries us.  We are in deep dodo.';
        RAISE NOTICE 'Narrator:  Do something!';

        ROLLBACK;
    end$$;


create or replace procedure usp_Battle4()
LANGUAGE plpgsql
AS $$
    BEGIN
        RAISE NOTICE '---------Step 4----------------';
        RAISE NOTICE '--- Constrain value -----';
        RAISE NOTICE 'Future-Christian: It is a little know fact that the percentage of people in Norway speaking Norwegian has reached 104.3.  I am updating the database to reflect this.';
        RAISE NOTICE ' ';
        RAISE NOTICE 'Narrator: Oh no!  Even his math skills are affected.  The percentage should never be above 100%%, obviously.';
        BEGIN
            update countrylanguage set percentage = 104.3 where countrycode = 'NOR' and language = 'Norwegian';
        EXCEPTION
                WHEN OTHERS THEN
                    RAISE NOTICE 'Future-Christian: Ack... That did not work either.';
                    RAISE NOTICE ' ';
                    RAISE NOTICE 'Narrator: Future-Christian has been stopped (again), percentage has been limited.';
                    RAISE NOTICE 'Step completed.';
                    INSERT INTO game_state values (4);
                RETURN;
        END;
        RAISE NOTICE 'Narrator:  Future-Christian updates the percentage of Norwegian speakers to 104.3%%. *facepalm*  Cannot trust this guy to do anything right';
        RAISE NOTICE 'Narrator:  Future-Christian succeeds.  Norwegian is at an all time high in Norway. Is it possible to constrain this value somehow?';
        RAISE NOTICE 'Narrator:  Please help us!';
        RAISE NOTICE 'Narrator:  Note that Jetbrains IDE do not show checks, but postgres supports it. Look up "Add constraint check"';

        ROLLBACK ;
    end$$;

create or replace procedure usp_Battle()
LANGUAGE plpgsql
AS $$
    DECLARE
        state integer;
    BEGIN
        state := (select coalesce(max(game_state.state),0) from game_state);

        CASE state
            when 0 THEN call usp_Battle1(); -- missing not null
            when 1 THEN call usp_Battle2(); -- missing foreign key
            when 2 THEN call usp_Battle3(); -- inserting logical duplicate
            when 3 THEN call usp_Battle4(); -- constraint value
            else
                RAISE Notice 'You have completed the game.  You have cleaned up after Past-Christian and have stopped Future-Christian (for now). ';
                RAISE Notice 'The base is now a safer place.';
                RAISE Notice 'Congratulations!';
        end case;

    end$$;